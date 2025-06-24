//
//  RegisterModel.swift
//  Projeto-MC656
//
//  Created by Gab on 13/06/25.
//

import Foundation

class RegisterModel: ObservableObject, CustomButtonDelegate {
    @Published var fullName: String = ""
    @Published var socialName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var cpf: String = ""

    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    
    private let service = RegisterService()

    @MainActor
    func register() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try fullName.check(.name)
            try socialName.check(.socialName)
            try email.check(.email)
            try phone.check(.phoneNumber)
            try cpf.check(.cpf)
            try password.check(.password)
            try password.comparePassword(with: passwordConfirmation)

            try await service.callRegister(name: fullName, socialName: socialName, email: email, phone: phone, cpf: cpf, password: password)

        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
}
