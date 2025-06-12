package com.MC_656.mobility.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;

class VehicleServiceTest {

    private VehicleService vehicleService;

    @BeforeEach
    void setup() {
        vehicleService = new VehicleService();
    }

    @Test
    @DisplayName("Deve registrar com sucesso um veículo válido")
    void deveRegistrarVeiculoValido() {
        // Classe de Equivalência: Dados Válidos
        assertTrue(vehicleService.registerVehicle("Bike-001", "BICYCLE", "Estação A", "AVAILABLE"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"", "B", "Este nome de veículo é absurdamente longo e foi criado com o único propósito de exceder o limite de caracteres"})
    @DisplayName("Deve rejeitar registro com nomes de veículo inválidos")
    void deveRejeitarNomesDeVeiculoInvalidos(String nomeInvalido) {
        // Classes de Equivalência: Nome vazio, muito curto, muito longo
        assertFalse(vehicleService.registerVehicle(nomeInvalido, "BICYCLE", "Estação A", "AVAILABLE"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"CAR", "TRUCK", "INVALID_TYPE"})
    @DisplayName("Deve rejeitar registro com tipos de veículo inválidos")
    void deveRejeitarTiposDeVeiculoInvalidos(String tipoInvalido) {
        // Classes de Equivalência: Tipos não suportados ou inválidos
        assertFalse(vehicleService.registerVehicle("Bike-002", tipoInvalido, "Estação A", "AVAILABLE"));
    }

    @ParameterizedTest
    @CsvSource({
            "AVAILABLE, IN_USE",      // Transição Válida
            "IN_USE, MAINTENANCE",    // Transição Válida
            "MAINTENANCE, AVAILABLE"  // Transição Válida
    })
    @DisplayName("Deve permitir transições de status válidas")
    void devePermitirTransicoesDeStatusValidas(String statusDe, String statusPara) {
        // Classes de Equivalência: Transições de status permitidas
        assertTrue(vehicleService.updateVehicleStatus(statusDe, statusPara));
    }

    @ParameterizedTest
    @CsvSource({
            "IN_USE, AVAILABLE",    // Transição Inválida (precisaria passar por outro estado)
            "MAINTENANCE, IN_USE",  // Transição Inválida
            "AVAILABLE, DELETED"    // Status de destino inválido
    })
    @DisplayName("Deve rejeitar transições de status inválidas")
    void deveRejeitarTransicoesDeStatusInvalidas(String statusDe, String statusPara) {
        // Classes de Equivalência: Transições inválidas ou para status inválido
        assertFalse(vehicleService.updateVehicleStatus(statusDe, statusPara));
    }

    @Test
    @DisplayName("Deve atualizar com sucesso a localização de um veículo")
    void deveAtualizarLocalizacaoComSucesso() {
        // Classe de Equivalência: Atualização válida
        assertTrue(vehicleService.updateVehicleLocation("VEH-001", "Estação B"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"", "X", "Nome de localização excessivamente longo que não cabe no banco de dados"})
    @DisplayName("Deve rejeitar atualizações de localização inválidas")
    void deveRejeitarAtualizacoesDeLocalizacaoInvalidas(String localizacaoInvalida) {
        // Classes de Equivalência: Localização vazia, curta ou longa demais
        assertFalse(vehicleService.updateVehicleLocation("VEH-001", localizacaoInvalida));
    }
}
