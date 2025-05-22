//
//  InitialView.swift
//  Projeto-MC656
//
//  Created by Gab on 18/05/25.
//

import SwiftUI

struct InitialView: View {
    private var screenPadding: CGFloat
    @State private var email: String
    @State private var pass: String
    private var model: InitialModel

    init(
        screenPadding: CGFloat = 24,
        email: String = String(),
        pass: String = String(),
        model: InitialModel = InitialModel()
    ) {
        self.screenPadding = screenPadding
        self.email = email
        self.pass = pass
        self.model = model
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                logo
                Spacer()
            }
            textFields
            Button("Ainda não tenho conta", action: {
                model.routeToRegister()
            })
            CustomButton(title: "Entrar") {
                Task {
                    await model.callAuth(email: email, password: pass)
                }
            }
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

    var logo: some View {
        Image(systemName: "bicycle.circle")
            .imageScale(.large)
            .font(.system(size: 160))
            .frame(width: 160, height: 160, alignment: .center)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.blue,
                                 Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            .cornerRadius(80)
    }

    var textFields: some View {
        HStack {
            CustomTextField(
                placeHolder: "E-mail",
                text: $email,
                rightIcon: "person.fill"
            )
            CustomTextField(
                placeHolder: "Senha",
                text: $pass,
                shouldBeSecure: true,
                rightIcon: "key.fill"
            )
        }
    }
}

#Preview {
    InitialView()
}
