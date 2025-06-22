//
//  VehicleListService.swift
//  Projeto-MC656
//
//  Created by Gab on 19/06/25.
//

import Foundation

class VehicleListService {
    func fetchVehicles() async throws -> [Vehicle] {
        // TODO: Implementar a chamada de back-end real
        return [
            Vehicle(
                id: UUID(),
                name: "Bicicleta Caloi",
                photo: "bicycle",
                isAvailable: true,
                description: "",
                pickupLocation: "",
                accessories: nil,
                requiresId: false,
                depositAmount: 0
            ),
            Vehicle(
                id: UUID(),
                name: "Patinete Elétrico",
                photo: "scooter",
                isAvailable: false,
                description: "",
                pickupLocation: "",
                accessories: nil,
                requiresId: false,
                depositAmount: 0
            ),
            Vehicle(
                id: UUID(),
                name: "Bicicleta Renault",
                photo: "bicycle",
                isAvailable: true,
                description: "",
                pickupLocation: "",
                accessories: nil,
                requiresId: false,
                depositAmount: 0
            )
        ]
    }
}
