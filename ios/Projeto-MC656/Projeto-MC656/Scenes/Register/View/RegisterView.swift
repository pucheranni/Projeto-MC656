//
//  RegisterView.swift
//  Projeto-MC656
//
//  Created by Gab on 13/06/25.
//

import SwiftUI

struct RegisterView: View {
    private var screenPadding: CGFloat = 24
    @StateObject private var model: RegisterModel = RegisterModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    logo
                    Spacer()
                }
                .padding(.bottom, 8)

                Group {
                    Text("Cadastro")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Os campos marcados com * são obrigatórios")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                formFields

                CustomButton(title: "Criar conta", delegate: model) {
                    Task {
                        await model.register()
                    }
                }
                .padding(.top, 8)
            }
            .padding(
                EdgeInsets(
                    top: screenPadding,
                    leading: screenPadding,
                    bottom: screenPadding,
                    trailing: screenPadding
                )
            )
        }
        .overlay(
            Group {
                if model.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.4))
                }
            }
        )
        .alert("Erro", isPresented: $model.showError) {
            Button("OK", role: .cancel) {
                model.showError = false
            }
        } message: {
            Text(model.errorMessage ?? "Erro desconhecido")
        }
    }

    var logo: some View {
        Image(systemName: "person.crop.circle.badge.plus")
            .imageScale(.large)
            .font(.system(size: 120))
            .frame(width: 160, height: 160, alignment: .center)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.green, Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            .cornerRadius(80)
    }

    var formFields: some View {
        VStack(spacing: 16) {
            CustomTextField(
                placeHolder: "Nome completo *",
                text: $model.fullName,
                rightIcon: "person.text.rectangle"
            )

            CustomTextField(
                placeHolder: "Nome social",
                text: $model.socialName,
                rightIcon: "person.fill"
            )

            CustomTextField(
                placeHolder: "E-mail *",
                text: $model.email,
                keyboardType: .emailAddress,
                rightIcon: "envelope.fill"
            )

            CustomTextField(
                placeHolder: "Celular *",
                text: $model.phone,
                keyboardType: .phonePad,
                rightIcon: "phone.fill"
            )

            CustomTextField(
                placeHolder: "CPF *",
                text: $model.cpf,
                keyboardType: .numberPad,
                rightIcon: "doc.text.fill"
            )

            CustomTextField(
                placeHolder: "Senha (mínimo 6 caracteres) *",
                text: $model.password,
                shouldBeSecure: true,
                rightIcon: "lock.fill"
            )

            CustomTextField(
                placeHolder: "Confirmar senha *",
                text: $model.passwordConfirmation,
                shouldBeSecure: true,
                rightIcon: "lock.fill"
            )
        }
    }
}

#Preview {
    RegisterView()
}
