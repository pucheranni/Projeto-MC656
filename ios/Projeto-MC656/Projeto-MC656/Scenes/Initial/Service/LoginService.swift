//
//  LoginService.swift
//  Projeto-MC656
//
//  Created by Gab on 11/06/25.
//

import Foundation

class LoginService {
    func callAuth(email: String, password: String) async throws -> LoginResponse {
//        try await callBack
        try await Task.sleep(nanoseconds: 1_000_000_000)

        return LoginResponse(token: "token_mockado")
    }
}
