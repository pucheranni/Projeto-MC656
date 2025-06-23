import Foundation

class VehicleTypeService {
    static let shared = VehicleTypeService()
    private let baseURL = "http://localhost:8080/api"
    
    func getVehicleTypes(completion: @escaping (Result<[String], ServiceError>) -> Void) {
        guard let token = AuthManager.shared.token else {
            completion(.failure(.unauthorized))
            return
        }
        guard let url = URL(string: "\(baseURL)/vehicles/types") else {
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
                let types = try JSONDecoder().decode([String].self, from: data)
                completion(.success(types))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}