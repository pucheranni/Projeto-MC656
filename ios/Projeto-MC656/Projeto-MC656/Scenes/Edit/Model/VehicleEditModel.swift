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
    private var vehicleId: UUID?

    var navigationTitle: String {
        isEditing ? "Editar Veículo" : "Cadastrar Veículo"
    }

    init(vehicle: Vehicle? = nil) {
        if let vehicle = vehicle {
            self.isEditing = true
            self.vehicleId = vehicle.id
            self.name = vehicle.name
            // resto
        } else {
            self.isEditing = false
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
