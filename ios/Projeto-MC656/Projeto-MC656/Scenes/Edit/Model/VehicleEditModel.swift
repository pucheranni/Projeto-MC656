//
//  VehicleEditModel.swift
//  Projeto-MC656
//
//  Created by Gab on 21/06/25.
//

import Foundation

enum VehicleType: String, CaseIterable, Identifiable {
    case bicicleta = "Bicicleta"
    case patinete = "Patinete"
    case patins = "Patins"
    case skate = "Skate"
    case outros = "Outros"
    var id: Self { self }
}

@MainActor
class VehicleEditModel: ObservableObject {
    @Published var vehicleType: VehicleType = .bicicleta
    // @Published var vehicleImage: Data? // Foto?
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var pickupLocation: String = ""

    @Published var includesHelmet: Bool = false
    @Published var includesLock: Bool = false
    @Published var includesLight: Bool = false
    @Published var includesPump: Bool = false
    @Published var otherAccessories: String = ""

    @Published var requiresId: Bool = false
    @Published var requiresDeposit: Bool = false
    @Published var depositAmount: String = ""

    var isEditing: Bool
    private var vehicleId: Int? // Changed from UUID? to Int?

    var navigationTitle: String {
        isEditing ? "Editar Veículo" : "Cadastrar Veículo"
    }

    init(vehicle: Vehicle? = nil) {
        if let vehicle = vehicle {
            self.isEditing = true
            self.vehicleId = vehicle.id // Now Int
            self.name = vehicle.make // Use make for name field in edit model
            self.description = vehicle.model // Use model for description field in edit model

            // Attempt to map other relevant fields from Vehicle to VehicleEditModel
            self.vehicleType = VehicleType(rawValue: vehicle.type) ?? .outros // Map string type back to enum
            self.pickupLocation = vehicle.pickupLocation ?? "" // Populate if available

            // Accessories: Vehicle has [String]?, EditModel has individual Bools and otherAccessories String.
            // This requires more complex mapping, for now, we'll leave it simple or clear them.
            // For simplicity in this step, we won't try to parse accessories back perfectly.
            self.includesHelmet = vehicle.accessories?.contains("Capacete") ?? false // Example
            self.includesLock = vehicle.accessories?.contains("Cadeado") ?? false   // Example
            // self.otherAccessories = ... // Would need to filter out known accessories and join others

            self.requiresId = vehicle.requiresId ?? false
            self.requiresDeposit = vehicle.depositAmount != nil && vehicle.depositAmount! > 0
            self.depositAmount = vehicle.depositAmount != nil ? String(format: "%.2f", vehicle.depositAmount!) : ""

        } else {
            self.isEditing = false
            // Default values are already set by @Published initializers
        }
    }

    func saveVehicle() async {
        if isEditing {
            print("Salvando: \(name)")
            // TODO: Implementar edição
        } else {
            print("Cadastrando: \(name)")
            let service = VehicleEditService()
            do {
                try await service.createVehicle(
                    name: name,
                    description: description,
                    pickupLocation: pickupLocation,
                    type: vehicleType.rawValue,
                    yearManufacture: 2024, // ou outro valor
                    licensePlate: nil, // ou outro valor
                    latitude: nil, // ou outro valor
                    longitude: nil, // ou outro valor
                    accessories: nil, // ou outro valor
                    requiresId: requiresId,
                    depositAmount: Double(depositAmount)
                )
                print("Veículo cadastrado com sucesso!")
            } catch {
                print("Erro ao cadastrar veículo: \(error.localizedDescription)")
            }
        }
    }

    func cancel() {
        print("cancelar")
    }

    func deleteVehicle() {
        print("Apagando: \(vehicleId?.uuidString ?? "N/A")")
    }
}
