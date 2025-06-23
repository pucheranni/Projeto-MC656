//
//  VehicleListService.swift
//  Projeto-MC656
//
//  Created by Gab on 19/06/25.
//

import Foundation

class VehicleListService {
    func fetchVehicles() async throws -> [Vehicle] {
        guard let token = AuthManager.shared.token else {
            throw ServiceError.serverError("Token de autenticação não encontrado")
        }
        guard let url = URL(string: "http://localhost:8080/api/vehicles?status=AVAILABLE") else {
            throw ServiceError.serverError("URL inválida")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

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
            let vehicles = try JSONDecoder().decode([Vehicle].self, from: data)
            return vehicles
        } catch {
            throw ServiceError.serverError("Erro ao decodificar resposta do servidor")
        }
    }
}

extension VehicleListService {
    func getVehicleDetails(vehicleId: Int, completion: @escaping (Result<Vehicle, ServiceError>) -> Void) {
        guard let token = AuthManager.shared.token else {
            completion(.failure(.unauthorized))
            return
        }
        let baseURL = "http://localhost:8080/api"
        guard let url = URL(string: "\(baseURL)/vehicles/\(vehicleId)") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard (200...299).contains(httpResponse.statusCode), let data = data else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            do {
                let vehicle = try JSONDecoder().decode(Vehicle.self, from: data)
                completion(.success(vehicle))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
