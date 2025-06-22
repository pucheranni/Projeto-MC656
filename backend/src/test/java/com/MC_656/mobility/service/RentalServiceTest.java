package com.MC_656.mobility.service;

import com.MC_656.mobility.model.Rental;
import com.MC_656.mobility.model.RentalPlan;
import com.MC_656.mobility.model.User;
import com.MC_656.mobility.model.Vehicle;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class RentalServiceTest {

    @InjectMocks // Using InjectMocks to test the calculateCost method directly, which is private.
                 // For a public method, I'd mock dependencies if any were used by it.
                 // Since calculateCost is private, I'll use a public wrapper or test through endRental.
                 // For simplicity here, I'll make calculateCost package-private or use reflection if needed,
                 // or test it via its public calling method (endRental).
                 // Let's assume calculateCost is refactored to be testable or tested via endRental.
                 // For this example, I'll test a conceptual public version of calculateCost or make it package-private.
                 // To make it directly testable without Spring context, I'll call it directly.
    private RentalService rentalService; // = new RentalService(); // If it had no autowired fields used by calculateCost

    // For the actual private method, this direct test is not possible without reflection or making it package-private.
    // Let's adjust RentalService to make calculateCost package-private for testing.

    private User testUser;
    private Vehicle testVehicle;

    @BeforeEach
    void setUp() {
        rentalService = new RentalService(); // Manually instantiate for this test scope
        testUser = new User("testuser", "password", "test@example.com", "Test User");
        testVehicle = new Vehicle("TestMake", "TestModel", 2023, "TESTPLATE", com.MC_656.mobility.model.VehicleType.E_BIKE, testUser);
    }

    private Rental createRental(LocalDateTime startTime, LocalDateTime endTime, RentalPlan plan) {
        Rental rental = new Rental(testUser, testVehicle, startTime, plan);
        rental.setEndTime(endTime);
        // No need to set ID or save for this specific cost calculation test
        return rental;
    }

    // Test cases for DAILY plan
    @Test
    void testCalculateCost_Daily_LessThanThreshold_ShouldBeZeroOrMin() {
        // Assuming MIN_RENTAL_MINUTES_FOR_DAILY is 60
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 1, 10, 30, 0); // 30 minutes
        Rental rental = createRental(start, end, RentalPlan.DAILY);
        BigDecimal cost = rentalService.calculateCost(rental); // Made package-private for testing
        assertEquals(new BigDecimal("0.00"), cost, "Cost for 30 mins daily should be 0.00 or a minimum fee");
    }

    @Test
    void testCalculateCost_Daily_JustOverThreshold_ShouldBeOneDay() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 1, 11, 5, 0); // 1 hour 5 minutes
        Rental rental = createRental(start, end, RentalPlan.DAILY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("20.00"), cost, "Cost for 1hr 5mins daily should be 1 day rate");
    }

    @Test
    void testCalculateCost_Daily_LessThanOneDay_ShouldBeOneDayRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 1, 15, 0, 0); // 5 hours
        Rental rental = createRental(start, end, RentalPlan.DAILY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("20.00"), cost, "Cost for 5 hours daily should be 1 day rate");
    }

    @Test
    void testCalculateCost_Daily_ExactlyOneDay_ShouldBeOneDayRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 2, 10, 0, 0); // 24 hours
        Rental rental = createRental(start, end, RentalPlan.DAILY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("20.00"), cost, "Cost for 1 day daily should be 1 day rate");
    }

    @Test
    void testCalculateCost_Daily_OneDayAndAHalf_ShouldBeTwoDaysRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 2, 22, 0, 0); // 1 day and 12 hours
        Rental rental = createRental(start, end, RentalPlan.DAILY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("40.00"), cost, "Cost for 1.5 days daily should be 2 days rate");
    }

    // Test cases for WEEKLY plan
    @Test
    void testCalculateCost_Weekly_LessThanOneWeek_ShouldBeOneWeekRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 5, 10, 0, 0); // 4 days
        Rental rental = createRental(start, end, RentalPlan.WEEKLY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("100.00"), cost, "Cost for 4 days weekly should be 1 week rate");
    }

    @Test
    void testCalculateCost_Weekly_ExactlyOneWeek_ShouldBeOneWeekRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 8, 10, 0, 0); // 7 days
        Rental rental = createRental(start, end, RentalPlan.WEEKLY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("100.00"), cost, "Cost for 1 week weekly should be 1 week rate");
    }

    @Test
    void testCalculateCost_Weekly_OneWeekAndPartial_ShouldBeTwoWeeksRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 10, 10, 0, 0); // 9 days
        Rental rental = createRental(start, end, RentalPlan.WEEKLY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("200.00"), cost, "Cost for 9 days weekly should be 2 weeks rate");
    }

    // Test cases for MONTHLY plan
    @Test
    void testCalculateCost_Monthly_LessThanOneMonth_ShouldBeOneMonthRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 15, 10, 0, 0); // 14 days
        Rental rental = createRental(start, end, RentalPlan.MONTHLY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("350.00"), cost, "Cost for 14 days monthly should be 1 month rate");
    }

    @Test
    void testCalculateCost_Monthly_ExactlyThirtyDays_ShouldBeOneMonthRate() {
        // Based on simplified 30-day month
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 31, 10, 0, 0); // 30 days
        Rental rental = createRental(start, end, RentalPlan.MONTHLY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("350.00"), cost, "Cost for 30 days monthly should be 1 month rate");
    }

    @Test
    void testCalculateCost_Monthly_OneMonthAndPartial_ShouldBeTwoMonthsRate() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 2, 15, 10, 0, 0); // Approx 45 days
        Rental rental = createRental(start, end, RentalPlan.MONTHLY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("700.00"), cost, "Cost for ~45 days monthly should be 2 months rate");
    }

    @Test
    void testCalculateCost_Daily_ZeroDuration_ShouldBeZero() {
        LocalDateTime start = LocalDateTime.of(2023, 1, 1, 10, 0, 0);
        LocalDateTime end = LocalDateTime.of(2023, 1, 1, 10, 0, 0); // 0 minutes
        Rental rental = createRental(start, end, RentalPlan.DAILY);
        BigDecimal cost = rentalService.calculateCost(rental);
        assertEquals(new BigDecimal("0.00"), cost, "Cost for 0 mins daily should be 0.00");
    }

}
