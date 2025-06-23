import Foundation

class VehicleEditService {
    func createVehicle(
        name: String,
        description: String?,
        pickupLocation: String?,
        type: String,
        yearManufacture: Int?,
        licensePlate: String?,
        latitude: Double?,
        longitude: Double?,
        accessories: [String]?,
        requiresId: Bool?,
        depositAmount: Double?
    ) async throws {
        guard let token = AuthManager.shared.token else {
            throw ServiceError.serverError("Token de autenticação não encontrado")
        }
        guard let url = URL(string: "http://localhost:8080/api/vehicles") else {
            throw ServiceError.serverError("URL inválida")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        var body: [String: Any] = [
            "make": name,
            "model": description ?? "",
            "yearManufacture": yearManufacture ?? 2024,
            "licensePlate": licensePlate ?? UUID().uuidString,
            "type": type,
            "latitude": latitude ?? 0.0,
            "longitude": longitude ?? 0.0
        ]
        // Adiciona outros campos opcionais se existirem
        if let accessories = accessories { body["accessories"] = accessories }
        if let requiresId = requiresId { body["requiresId"] = requiresId }
        if let depositAmount = depositAmount { body["depositAmount"] = depositAmount }

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
        // Sucesso: veículo criado
    }
}
