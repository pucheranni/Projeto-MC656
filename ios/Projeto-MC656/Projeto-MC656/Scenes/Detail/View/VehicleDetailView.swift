//
//  VehicleDetailView.swift
//  Projeto-MC656
//
//  Created by Gab on 21/06/25.
//

import SwiftUI

struct VehicleDetailView: View {
    let vehicle: Vehicle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Use a default system image as 'photo' is not available from backend
                Image(systemName: "bicycle.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200) // Adjusted height
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.purple) // Added color for visibility
                    .padding() // Added padding around image
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(vehicle.displayName) // Use computed property
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Text(vehicle.isActuallyAvailable ? "Disponível" : "Indisponível") // Use computed property
                            .font(.headline)
                            .foregroundColor(vehicle.isActuallyAvailable ? .green : .orange)
                            .padding(8)
                            .background(vehicle.isActuallyAvailable ? .green.opacity(0.1) : .orange.opacity(0.1))
                            .cornerRadius(8)
                    }

                    Text("Detalhes do Veículo") // Changed section title
                        .font(.title2)
                        .fontWeight(.semibold)

                    // Displaying more info from the vehicle object
                    InfoRow(label: "Marca", value: vehicle.make)
                    InfoRow(label: "Modelo", value: vehicle.model)
                    InfoRow(label: "Ano", value: "\(vehicle.yearManufacture)")
                    InfoRow(label: "Placa", value: vehicle.licensePlate)
                    InfoRow(label: "Tipo", value: vehicle.type)
                    InfoRow(label: "Proprietário", value: vehicle.ownerUsername ?? "N/A")

                    // Display description if available, otherwise a default message
                    Text("Descrição Adicional")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(vehicle.description ?? "Nenhuma descrição adicional fornecida.")
                        .foregroundColor(.secondary)

                    Text("Acessórios Inclusos")
                        .font(.title2)
                        .fontWeight(.semibold)
                    if let accessories = vehicle.accessories, !accessories.isEmpty {
                        ForEach(accessories, id: \.self) { accessory in
                            Label(accessory, systemImage: "checkmark.circle.fill").foregroundColor(.green)
                        }
                    } else {
                        Text("Nenhum acessório informado.")
                            .foregroundColor(.secondary)
                    }

                    Text("Local de Retirada")
                        .font(.title2)
                        .fontWeight(.semibold)
                    // Display pickupLocation if available, otherwise coordinates or default message
                    Text(vehicle.pickupLocation ?? (vehicle.latitude != nil && vehicle.longitude != nil ? "Coordenadas: \(String(format: "%.4f", vehicle.latitude!)), \(String(format: "%.4f", vehicle.longitude!))" : "Localização não disponível"))
                        .foregroundColor(.secondary)

                    Text("Requisitos")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Label(vehicle.requiresId ?? false ? "Exige documento de identificação" : "Não exige documento de identificação", systemImage: (vehicle.requiresId ?? false ? "checkmark.shield.fill" : "xmark.shield.fill")).foregroundColor((vehicle.requiresId ?? false ? .blue : .gray))
                    
                    if let deposit = vehicle.depositAmount, deposit > 0 {
                        Label("Exige caução de R$ \(String(format: "%.2f", deposit))", systemImage: "checkmark.shield.fill").foregroundColor(.blue)
                    } else {
                        Label("Não exige caução", systemImage: "xmark.shield.fill").foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                Spacer()
                Button(action: {
                    // Action for renting vehicle - current implementation just prints
                    print("Solicitando empréstimo para o veículo: \(vehicle.displayName), ID: \(vehicle.id)")
                }) {
                    Text("Pedir Empréstimo")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vehicle.isActuallyAvailable ? Color.accentColor : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!vehicle.isActuallyAvailable) // Use computed property
                .padding()
            }
        }
        .navigationTitle("Detalhes do Veículo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Helper view for consistent row display
struct InfoRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.medium)
            Text(value)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}


#Preview {
    NavigationStack {
        VehicleDetailView(
            vehicle: Vehicle( // Sample data for preview, matching new structure
                id: 1,
                make: "Caloi",
                model: "Explorer",
                yearManufacture: 2023,
                licensePlate: "BRA0S19",
                type: "E_BIKE",
                status: "AVAILABLE",
                description: "Uma ótima e-bike para cidade e trilhas leves.",
                pickupLocation: "Estação Central da Unicamp",
                accessories: ["Capacete", "Cadeado", "Luzes LED"],
                requiresId: true,
                depositAmount: 50.0,
                latitude: -22.8170,
                longitude: -47.0680,
                ownerUsername: "barbara.melo"
            )
        )
    }
}
