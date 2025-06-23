//
//  LoginService.swift
//  Projeto-MC656
//
//  Created by Gab on 11/06/25.
//

import Foundation

class LoginService {
    func callAuth(email: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "http://localhost:8080/api/auth/login") else {
            throw ServiceError.serverError("URL inválida")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "username": email,
            "password": password
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.serverError("Resposta inválida do servidor")
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw ServiceError.invalidCredentials
            }
            throw ServiceError.serverError("Erro do servidor: \(httpResponse.statusCode)")
        }
        do {
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            return loginResponse
        } catch {
            throw ServiceError.serverError("Erro ao decodificar resposta do servidor")
        }
    }
}
