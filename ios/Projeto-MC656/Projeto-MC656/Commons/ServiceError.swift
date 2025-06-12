//
//  ServiceError.swift
//  Projeto-MC656
//
//  Created by Gab on 11/06/25.
//

import Foundation

enum ServiceError: Error, LocalizedError {
    case invalidCredentials
    case serverError(String)
    case invalidEmail
    case invalidPassword

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "E-mail ou senha incorretos."
        case .serverError(let message):
            return message
        case .invalidEmail:
            return "E-mail inválido."
        case .invalidPassword:
            return "Dados inválidos."
        }
    }
}
