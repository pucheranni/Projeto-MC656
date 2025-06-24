package com.MC_656.mobility.service;

import com.MC_656.mobility.dto.StartRentalRequest;
import com.MC_656.mobility.exception.BadRequestException;
import com.MC_656.mobility.exception.ResourceNotFoundException;
import com.MC_656.mobility.model.*;
import com.MC_656.mobility.repository.RentalRepository;
import com.MC_656.mobility.repository.UserRepository;
import com.MC_656.mobility.repository.VehicleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class RentalService {

    @Autowired
    private RentalRepository rentalRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private UserRepository userRepository;

    // Placeholder costs - these would typically come from a config or pricing service
    private static final BigDecimal DAILY_RATE = new BigDecimal("20.00");
    private static final BigDecimal WEEKLY_RATE = new BigDecimal("100.00");
    private static final BigDecimal MONTHLY_RATE = new BigDecimal("350.00");
    private static final long MIN_RENTAL_MINUTES_FOR_DAILY = 60; // e.g. charge a day if rented for at least 1 hour.

    @Transactional
    public Rental startRental(StartRentalRequest startRentalRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();
        User user = userRepository.findByUsername(currentPrincipalName)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", currentPrincipalName));

        Vehicle vehicle = vehicleRepository.findById(startRentalRequest.getVehicleId())
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle", "id", startRentalRequest.getVehicleId()));

        if (vehicle.getStatus() != VehicleStatus.AVAILABLE) {
            throw new BadRequestException("Vehicle " + vehicle.getLicensePlate() + " is not available for rental. Current status: " + vehicle.getStatus());
        }

        // Check if user already has an active rental
        if(rentalRepository.findByUserAndEndTimeIsNull(user).isPresent()){
            throw new BadRequestException("User " + user.getUsername() + " already has an active rental.");
        }

        Rental rental = new Rental();
        rental.setUser(user);
        rental.setVehicle(vehicle);
        rental.setStartTime(LocalDateTime.now());
        rental.setRentalPlan(startRentalRequest.getRentalPlan());
        // totalCost is null until rental ends

        vehicle.setStatus(VehicleStatus.RENTED);
        vehicleRepository.save(vehicle);

        return rentalRepository.save(rental);
    }

    @Transactional
    public Rental endRental(Long rentalId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();
        User user = userRepository.findByUsername(currentPrincipalName)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", currentPrincipalName));

        Rental rental = rentalRepository.findById(rentalId)
                .orElseThrow(() -> new ResourceNotFoundException("Rental", "id", rentalId));

        if (rental.getEndTime() != null) {
            throw new BadRequestException("Rental " + rentalId + " has already been ended.");
        }

        // Ensure the user ending the rental is the one who started it (or an admin, if roles were implemented)
        if (!rental.getUser().getId().equals(user.getId())) {
            throw new BadRequestException("User " + user.getUsername() + " is not authorized to end rental " + rentalId);
        }

        rental.setEndTime(LocalDateTime.now());
        rental.setTotalCost(calculateCost(rental));

        Vehicle vehicle = rental.getVehicle();
        vehicle.setStatus(VehicleStatus.AVAILABLE); // Or potentially MAINTENANCE if issues reported
        vehicleRepository.save(vehicle);

        return rentalRepository.save(rental);
    }

    // Changed to package-private for testing
    BigDecimal calculateCost(Rental rental) {
        if (rental.getStartTime() == null || rental.getEndTime() == null) {
            throw new IllegalStateException("Cannot calculate cost for a rental that hasn't started or ended.");
        }

        Duration duration = Duration.between(rental.getStartTime(), rental.getEndTime());
        long days = duration.toDays();
        long hours = duration.toHoursPart();
        long minutes = duration.toMinutesPart();


        switch (rental.getRentalPlan()) {
            case DAILY:
                if (duration.toMinutes() == 0) { // Zero duration specifically
                    return BigDecimal.ZERO;
                }
                // If duration is less than the minimum rental minutes threshold, charge zero.
                // (Based on test "testCalculateCost_Daily_LessThanThreshold_ShouldBeZeroOrMin")
                if (duration.toMinutes() < MIN_RENTAL_MINUTES_FOR_DAILY) {
                    return BigDecimal.ZERO;
                }

                // If MIN_RENTAL_MINUTES_FOR_DAILY or more
                long calculatedDays = days; // days from duration.toDays()
                // If there are any hours or minutes part, it means it's a partial day, so increment days.
                if (hours > 0 || minutes > 0) {
                    calculatedDays++;
                }
                // Ensure at least one day is charged if it met/exceeded the threshold and wasn't zero.
                return DAILY_RATE.multiply(BigDecimal.valueOf(Math.max(1, calculatedDays)));

            case WEEKLY:
                long weeks = days / 7;
                if (days % 7 > 0) weeks++; // Partial week counts as a full week
                return WEEKLY_RATE.multiply(BigDecimal.valueOf(Math.max(1, weeks)));

            case MONTHLY:
                // Simplified: count any part of a 30-day period as a month
                long months = days / 30; // Approximation
                if (days % 30 > 0) months++;
                return MONTHLY_RATE.multiply(BigDecimal.valueOf(Math.max(1, months)));

            default:
                throw new BadRequestException("Unsupported rental plan: " + rental.getRentalPlan());
        }
    }

    public List<Rental> getRentalHistoryForCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();
        User user = userRepository.findByUsername(currentPrincipalName)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", currentPrincipalName));
        return rentalRepository.findByUserOrderByStartTimeDesc(user);
    }

    public Rental getActiveRentalForCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();
        User user = userRepository.findByUsername(currentPrincipalName)
                .orElseThrow(() -> new ResourceNotFoundException("User", "username", currentPrincipalName));
        return rentalRepository.findByUserAndEndTimeIsNull(user).orElse(null);
    }
}
