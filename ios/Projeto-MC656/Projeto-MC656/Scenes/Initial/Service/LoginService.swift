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

    private func checkEmail(_ email: String) throws {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            throw ServiceError.invalidEmail
        }
    }

    private func checkPassword(_ password: String) throws {
        guard password.count >= 6 else {
            throw ServiceError.invalidPassword
        }
    }
}
