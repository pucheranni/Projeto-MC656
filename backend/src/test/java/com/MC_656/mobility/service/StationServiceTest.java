package com.MC_656.mobility.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;

class StationServiceTest {

    private StationService stationService;

    @BeforeEach
    void setup() {
        // Garante que uma nova instância do serviço seja criada para cada teste
        stationService = new StationService();
    }

    @Test
    @DisplayName("Deve registrar com sucesso uma estação com dados válidos")
    void deveRegistrarEstacaoValida() {
        // Classe de Equivalência: Dados Válidos
        assertTrue(stationService.registerStation("Estação Central", "Rua Principal, 123", 20, -22.9, -47.0),
                "O registro deve ser bem-sucedido para dados válidos.");
    }

    @ParameterizedTest
    @ValueSource(strings = {"", "A", "Nome de estação extremamente longo que excede o limite de caracteres estabelecido pelo sistema de software"})
    @DisplayName("Deve rejeitar registro com nomes de estação inválidos")
    void deveRejeitarNomesInvalidos(String nomeInvalido) {
        // Classes de Equivalência: Nome vazio, muito curto, muito longo
        assertFalse(stationService.registerStation(nomeInvalido, "Endereço Válido", 10, -22.9, -47.0),
                "O registro deve falhar para nomes inválidos: '" + nomeInvalido + "'");
    }

    @ParameterizedTest
    @ValueSource(ints = {0, -1, 101})
    @DisplayName("Deve rejeitar registro com capacidades de estação inválidas")
    void deveRejeitarCapacidadesInvalidas(int capacidadeInvalida) {
        // Classes de Equivalência e Valores Limite: Capacidade zero, negativa, acima do limite
        assertFalse(stationService.registerStation("Estação Capacidade", "Endereço Válido", capacidadeInvalida, -22.9, -47.0),
                "O registro deve falhar para capacidade inválida: " + capacidadeInvalida);
    }

    @ParameterizedTest
    @CsvSource({
            "-90.1, -47.0",   // Limite: Latitude abaixo do permitido
            "90.1, -47.0",    // Limite: Latitude acima do permitido
            "-22.9, -180.1",  // Limite: Longitude abaixo do permitido
            "-22.9, 180.1"    // Limite: Longitude acima do permitido
    })
    @DisplayName("Deve rejeitar registro com coordenadas inválidas")
    void deveRejeitarCoordenadasInvalidas(double latitude, double longitude) {
        // Análise de Valor Limite: Coordenadas fora do intervalo
        assertFalse(stationService.registerStation("Estação Coordenadas", "Endereço Válido", 10, latitude, longitude),
                "O registro deve falhar para coordenadas fora do intervalo.");
    }

    @Test
    @DisplayName("Deve atualizar com sucesso a capacidade de uma estação")
    void deveAtualizarCapacidadeComSucesso() {
        // Classe de Equivalência: Atualização Válida
        assertTrue(stationService.updateStationCapacity("STA001", 15),
                "A atualização de capacidade deve ser bem-sucedida para valores válidos.");
    }

    @ParameterizedTest
    @ValueSource(ints = {-1, -10, 101})
    @DisplayName("Deve rejeitar atualizações de capacidade inválidas")
    void deveRejeitarAtualizacoesDeCapacidadeInvalidas(int capacidadeInvalida) {
        // Classe de Equivalência e Limites: Capacidade negativa ou acima do limite
        assertFalse(stationService.updateStationCapacity("STA001", capacidadeInvalida),
                "A atualização de capacidade deve falhar para valores inválidos.");
    }
    
    @Test
    @DisplayName("Deve retornar 'AVAILABLE' para uma estação conhecida")
    void deveVerificarDisponibilidadeComSucesso() {
        // Classe de Equivalência: Verificação de estação existente
        assertEquals("AVAILABLE", stationService.checkStationAvailability("STA001"),
                "A verificação de disponibilidade deve retornar 'AVAILABLE'.");
    }

    @ParameterizedTest
    @CsvSource({
            "'FULL', 10, 10",
            "'AVAILABLE', 5, 10",
            "'AVAILABLE', 0, 10" // Limite
    })
    @DisplayName("Deve informar o status da estação corretamente")
    void deveInformarStatusCorretamente(String statusEsperado, int veiculosAtuais, int capacidade) {
        // Classes de Equivalência e Limites: Estação cheia, vazia, com vagas
        assertEquals(statusEsperado, stationService.reportStationStatus(veiculosAtuais, capacidade));
    }
}
