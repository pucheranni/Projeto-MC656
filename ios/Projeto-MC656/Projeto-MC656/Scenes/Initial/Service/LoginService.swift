//
//  LoginService.swift
//  Projeto-MC656
//
//  Created by Gab on 11/06/25.
//

import Foundation

class LoginService {
    func callAuth(email: String, password: String) async throws -> LoginResponse {
        try checkEmail(email)
        try checkPassword(password)

//        try await callBack
        try await Task.sleep(nanoseconds: 1_000_000_000)

        return LoginResponse(token: "token_mockado")
    }

    func checkEmail(_ email: String) throws {
        let emailRegex = "^(?!.*[\\.\\+\\_\\-\\@]{2})(?![0-9]+@)[\\w\\_\\-\\.\\+]+@([\\w-]+\\.)+(?![0-9]+$)[\\w-]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            throw ServiceError.invalidEmail
        }
    }

    func checkPassword(_ password: String) throws {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        guard passwordPredicate.evaluate(with: password) else {
            throw ServiceError.invalidPassword
        }
    }
}
