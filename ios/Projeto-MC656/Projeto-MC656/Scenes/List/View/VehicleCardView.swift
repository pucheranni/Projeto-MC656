//
//  VehicleCardView.swift
//  Projeto-MC656
//
//  Created by Gab on 19/06/25.
//

import SwiftUI

struct VehicleCardView: View {
    let vehicle: Vehicle

    var body: some View {
        HStack(spacing: 16) {
            // Use a default system image as 'photo' is not available
            Image(systemName: "bicycle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60) // Adjusted size
                .foregroundColor(.purple)
                .padding(10)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                Text(vehicle.displayName) // Use computed property
                    .font(.headline)

                Text(vehicle.isActuallyAvailable ? "Disponível" : "Indisponível") // Use computed property
                    .font(.subheadline)
                    .foregroundColor(vehicle.isActuallyAvailable ? .green : .red)

                // Optionally, add more brief info if desired, e.g., type
                Text("Tipo: \(vehicle.type)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
