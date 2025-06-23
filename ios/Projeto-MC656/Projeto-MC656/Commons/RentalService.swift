import Foundation

struct StartRentalRequest: Codable {
    let vehicleId: Int
}

struct StartRentalResponse: Codable {
    let id: Int
    let vehicleId: Int
    let userId: Int
    let startTime: String
    // Adicione outros campos conforme resposta do backend
}

struct RentalHistoryItem: Codable {
    let id: Int
    let vehicleId: Int
    let userId: Int
    let startTime: String
    let endTime: String?
    // Adicione outros campos conforme resposta do backend
}

class RentalService {
    static let shared = RentalService()
    private let baseURL = "http://localhost:8080/api"
    
    func startRental(vehicleId: Int, completion: @escaping (Result<StartRentalResponse, ServiceError>) -> Void) {
        guard let token = AuthManager.shared.token else {
            completion(.failure(.unauthorized))
            return
        }
        guard let url = URL(string: "\(baseURL)/rentals/start") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body = StartRentalRequest(vehicleId: vehicleId)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(.encodingError))
            return
        }
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
                let rentalResponse = try JSONDecoder().decode(StartRentalResponse.self, from: data)
                completion(.success(rentalResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    func endRental(rentalId: Int, completion: @escaping (Result<Void, ServiceError>) -> Void) {
        guard let token = AuthManager.shared.token else {
            completion(.failure(.unauthorized))
            return
        }
        guard let url = URL(string: "\(baseURL)/rentals/\(rentalId)/end") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Se precisar de body, adicione aqui
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            completion(.success(()))
        }
        task.resume()
    }
}

extension RentalService {
    func getUserRentalHistory(completion: @escaping (Result<[RentalHistoryItem], ServiceError>) -> Void) {
        guard let token = AuthManager.shared.token else {
            completion(.failure(.unauthorized))
            return
        }
        guard let url = URL(string: "\(baseURL)/users/me/history") else {
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
                let history = try JSONDecoder().decode([RentalHistoryItem].self, from: data)
                completion(.success(history))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
