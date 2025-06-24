//
//  Vehicle.swift
//  Projeto-MC656
//
//  Created by Gab on 19/06/25.
//

import Foundation

struct Vehicle: Identifiable, Codable {
    let id: Int // Changed from UUID to Int (to match Long from backend)
    let make: String
    let model: String
    let yearManufacture: Int
    let licensePlate: String
    let type: String // Raw VehicleType enum string
    let status: String // Raw VehicleStatus enum string

    // Optional fields that might not be directly in VehicleResponse but are in UI
    let description: String? // This specific field is not in VehicleResponse, will be nil or custom handled
    let pickupLocation: String? // This specific field is not in VehicleResponse, will be nil or derived
    let accessories: [String]? // Not in VehicleResponse
    let requiresId: Bool? // Not in VehicleResponse
    let depositAmount: Double? // Not in VehicleResponse

    // Fields from VehicleResponse that were missing or need mapping
    let latitude: Double?
    let longitude: Double?
    let ownerUsername: String?

    // Computed properties
    var displayName: String {
        "\(make) \(model)"
    }

    var isActuallyAvailable: Bool {
        status == "AVAILABLE"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case make, model, yearManufacture, licensePlate, type, status
        case latitude, longitude
        case ownerUsername
        // Properties not in backend response, but kept for potential future use or if decoded from elsewhere.
        // If they are never in the JSON, they will be nil if optional, or cause decoding error if not.
        // For this task, we assume they are not in the JSON from this specific endpoint.
        case description
        case pickupLocation = "pickup_location" // Assuming if it ever comes, it's snake_case
        case accessories
        case requiresId = "requires_id"         // Assuming if it ever comes, it's snake_case
        case depositAmount = "deposit_amount"   // Assuming if it ever comes, it's snake_case
    }
}
