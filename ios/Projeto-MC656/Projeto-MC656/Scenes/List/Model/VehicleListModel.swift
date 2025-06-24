//
//  VehicleListModel.swift
//  Projeto-MC656
//
//  Created by Gab on 19/06/25.
//

import Foundation

@MainActor
class VehicleListModel: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = VehicleListService()

    func loadVehicles() async {
        isLoading = true
        errorMessage = nil

        do {
            vehicles = try await service.fetchVehicles()
        } catch {
            errorMessage = "Falha ao carregar os veículos. Tente novamente mais tarde."
        }

        isLoading = false
    }
}
