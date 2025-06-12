package com.MC_656.mobility.service;

// Classe de serviço para gerenciar a lógica de negócio das estações.
public class StationService {

    /**
     * Registra uma nova estação, validando os dados de entrada.
     * @return true se os dados forem válidos, false caso contrário.
     */
    public boolean registerStation(String name, String address, int capacity, double latitude, double longitude) {
        // Validação dos dados de entrada
        if (name == null || name.trim().isEmpty() || name.length() < 2 || name.length() > 100) {
            return false;
        }
        if (address == null || address.trim().isEmpty()) {
            return false;
        }
        if (capacity <= 0 || capacity > 100) {
            return false;
        }
        if (latitude < -90 || latitude > 90) {
            return false;
        }
        if (longitude < -180 || longitude > 180) {
            return false;
        }
        return true; // Retorna true se todas as validações passarem
    }

    /**
     * Atualiza a capacidade de uma estação.
     * @return true se os dados forem válidos, false caso contrário.
     */
    public boolean updateStationCapacity(String stationId, int newCapacity) {
        if (stationId == null || stationId.isEmpty() || newCapacity < 0 || newCapacity > 100) {
            return false;
        }
        return true;
    }

    /**
     * Verifica a disponibilidade de uma estação.
     * @return O status de disponibilidade.
     */
    public String checkStationAvailability(String stationId) {
        if (stationId == null || stationId.isEmpty()) {
            return "UNKNOWN";
        }
        // Lógica simplificada
        return "AVAILABLE";
    }

    /**
     * Informa o status da estação com base na ocupação.
     * @return O status calculado (FULL, AVAILABLE, etc.).
     */
    public String reportStationStatus(int currentVehicles, int capacity) {
        if (currentVehicles < 0 || capacity <= 0 || currentVehicles > capacity) {
            return "INVALID_DATA";
        }
        if (currentVehicles == capacity) {
            return "FULL";
        }
        // Para este stub, qualquer outro status é "disponível".
        // Uma implementação real poderia ter "MANUTENÇÃO", etc.
        return "AVAILABLE";
    }
}
