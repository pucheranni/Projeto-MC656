package com.MC_656.mobility.service;

import java.util.Arrays;
import java.util.List;

// Classe de serviço para gerenciar a lógica de negócio de veículos.
public class VehicleService {

    private static final List<String> ALLOWED_TYPES = Arrays.asList("BICYCLE", "SCOOTER");
    private static final List<String> ALLOWED_STATUSES = Arrays.asList("AVAILABLE", "IN_USE", "MAINTENANCE");

    public boolean registerVehicle(String name, String type, String location, String status) {
        if (!isNameValid(name) || !isTypeValid(type) || !isLocationValid(location) || !isStatusValid(status)) {
            return false;
        }
        return true;
    }

    public boolean updateVehicleStatus(String fromStatus, String toStatus) {
        if (!isStatusValid(fromStatus) || !isStatusValid(toStatus)) {
            return false;
        }
        if ("IN_USE".equals(fromStatus) && "AVAILABLE".equals(toStatus)) return false;
        if ("MAINTENANCE".equals(fromStatus) && "IN_USE".equals(toStatus)) return false;
        return true;
    }

    // AQUI ESTÁ A LÓGICA CORRIGIDA E COMPLETA
    public boolean updateVehicleLocation(String vehicleId, String newLocation) {
        if (vehicleId == null || vehicleId.isEmpty() || !isLocationValid(newLocation)) {
            return false;
        }
        return true;
    }

    private boolean isNameValid(String name) {
        return name != null && !name.trim().isEmpty() && name.length() >= 2 && name.length() <= 100;
    }

    private boolean isTypeValid(String type) {
        return type != null && ALLOWED_TYPES.contains(type.toUpperCase());
    }

    private boolean isLocationValid(String location) {
        return location != null && !location.trim().isEmpty() && location.length() >= 2 && location.length() <= 100;
    }

    private boolean isStatusValid(String status) {
        if("DELETED".equals(status)) return false;
        return status != null && ALLOWED_STATUSES.contains(status.toUpperCase());
    }
}