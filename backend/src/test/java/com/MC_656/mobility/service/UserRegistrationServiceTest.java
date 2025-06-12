package com.MC_656.mobility.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import static org.junit.jupiter.api.Assertions.*;

class UserRegistrationServiceTest {

    private UserRegistrationService userRegistrationService;

    @BeforeEach
    void setup() {
        userRegistrationService = new UserRegistrationService();
    }

    @Test
    @DisplayName("Deve registrar com sucesso um usuário com dados válidos")
    void deveRegistrarUsuarioValido() {
        // Classe de Equivalência: Dados Válidos
        assertTrue(userRegistrationService.registerUser("John Doe", "john.doe@example.com", "12345678900", "11999999999"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"", "J", "Nome muito longo que ultrapassa o limite de cem caracteres que foi definido nas regras de negócio da aplicação"})
    @DisplayName("Deve rejeitar registro com nomes inválidos")
    void deveRejeitarNomesInvalidos(String nomeInvalido) {
        // Classes de Equivalência: Nome vazio, muito curto, muito longo
        assertFalse(userRegistrationService.registerUser(nomeInvalido, "test@example.com", "12345678900", "11987654321"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"email-invalido", "email@.com", "email@dominio.", "@dominio.com"})
    @DisplayName("Deve rejeitar registro com formatos de e-mail inválidos")
    void deveRejeitarEmailsInvalidos(String emailInvalido) {
        // Classes de Equivalência: Formatos de email inválidos
        assertFalse(userRegistrationService.registerUser("Test User", emailInvalido, "12345678900", "11987654321"));
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "123456789",      // CPF muito curto
            "123456789012",   // CPF muito longo
            "123.abc.789-00", // Formato com letras
            "00000000000",    // CPF inválido (todos os dígitos iguais)
            "11111111111"     // CPF inválido (todos os dígitos iguais)
    })
    @DisplayName("Deve rejeitar registro com números de CPF inválidos")
    void deveRejeitarCpfsInvalidos(String cpfInvalido) {
        assertFalse(userRegistrationService.registerUser("Test User", "test@example.com", cpfInvalido, "11987654321"));
    }
    
    @Test
    @DisplayName("Deve aceitar CPF com formatação válida")
    void deveAceitarCpfFormatado() {
        assertTrue(userRegistrationService.registerUser("Test User", "test@example.com", "123.456.789-01", "11987654321"));
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "119999999",      // Telefone muito curto
            "119999999999",   // Telefone muito longo
            "1199999999a",    // Contém letras
            "1199999-999!"    // Contém caracteres especiais inválidos
    })
    @DisplayName("Deve rejeitar registro com números de telefone inválidos")
    void deveRejeitarTelefonesInvalidos(String telefoneInvalido) {
        // Classes de Equivalência e Limites: Comprimento e caracteres
        assertFalse(userRegistrationService.registerUser("Test User", "test@example.com", "12345678900", telefoneInvalido));
    }
    
    @Test
    @DisplayName("Deve aceitar telefone com formatação válida")
    void deveAceitarTelefoneFormatado() {
        assertTrue(userRegistrationService.registerUser("Test User", "test@example.com", "12345678901", "(11) 98765-4321"));
    }
}
