//
//  InitialModel.swift
//  Projeto-MC656
//
//  Created by Gab on 19/05/25.
//

import SwiftUI

class InitialModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false

    private let service = LoginService()

    @MainActor
    func login() async {
        isLoading = true
        errorMessage = nil

        do {
            try email.check(.email)
            try password.check(.password)
            let response = try await service.callAuth(email: email, password: password)
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

extension InitialModel: CustomButtonDelegate {
    
}
