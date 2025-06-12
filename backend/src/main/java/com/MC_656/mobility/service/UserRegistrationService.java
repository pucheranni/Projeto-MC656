package com.MC_656.mobility.service;

import java.util.regex.Pattern;

// Classe de serviço para gerenciar a lógica de registro de usuários.
public class UserRegistrationService {

    // Regex simples para validação de e-mail.
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");

    /**
     * Registra um novo usuário, validando todos os campos.
     * @return true se o registro for válido, false caso contrário.
     */
    public boolean registerUser(String name, String email, String document, String phone) {
        if (!isNameValid(name) || !isEmailValid(email) || !isCpfValid(document) || !isPhoneValid(phone)) {
            return false;
        }
        return true;
    }

    private boolean isNameValid(String name) {
        return name != null && !name.trim().isEmpty() && name.length() >= 2 && name.length() <= 100;
    }

    private boolean isEmailValid(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    private boolean isCpfValid(String cpf) {
        if (cpf == null) return false;
        // Remove caracteres não numéricos
        String cleanedCpf = cpf.replaceAll("[^0-9]", "");
        if (cleanedCpf.length() != 11) return false;
        // Verifica se todos os dígitos são iguais (ex: "11111111111"), o que é inválido
        if (cleanedCpf.matches("(\\d)\\1{10}")) return false;
        return true;
    }

    private boolean isPhoneValid(String phone) {
        if (phone == null) return false;
        // Remove caracteres não numéricos
        String cleanedPhone = phone.replaceAll("[^0-9]", "");
        // Verifica se contém apenas números e tem 10 ou 11 dígitos
        return cleanedPhone.length() >= 10 && cleanedPhone.length() <= 11 && phone.matches("^[0-9() -]*$");
    }
}
