//
//  InitialView.swift
//  Projeto-MC656
//
//  Created by Gab on 18/05/25.
//

import SwiftUI

struct InitialView: View {
    private var screenPadding: CGFloat = 24
    @State private var email: String = ""
    @State private var pass: String = ""
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            FloatingTextField(
                placeHolder: "E-mail",
                text: $email,
                rightIcon: "person.fill"
            )
            FloatingTextField(
                placeHolder: "Senha",
                text: $pass,
                shouldBeSecure: true,
                rightIcon: "key.fill"
            )
            Button("Ainda não tenho conta", action: {
                // Levar ao cadastro
            })
            Button(action: {
                
            }, label: {
                Text("Entrar")
                    .colorInvert()
            })
            .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48)
            .foregroundColor(.black)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.blue,
                                 Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            .cornerRadius(16)
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
}

struct FloatingTextField: View {
    private let textFieldHeight: CGFloat = 50
    private let placeHolderText: String
    @Binding private var text: String
    @State private var isEditing = false
    @State var shouldBeSecure = false
    let rightIcon: String?
    
    private var shouldPlaceHolderMove: Bool {
        isEditing || (text.count != 0)
    }
    
    // MARK: - init
    public init(
        placeHolder: String,
        text: Binding<String>,
        shouldBeSecure: Bool = false,
        rightIcon: String? = nil
    ) {
        self._text = text
        self.placeHolderText = placeHolder
        self.shouldBeSecure = shouldBeSecure
        self.rightIcon = rightIcon
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if shouldBeSecure {
                    SecureField(String(), text: $text)
                    .foregroundColor(Color.primary)
                    .frame(alignment: .leading)
                } else {
                    TextField(String(), text: $text)
                    .foregroundColor(Color.primary)
                    .animation(Animation.easeInOut(duration: 0.4), value: EdgeInsets())
                    .frame(alignment: .leading)
                }
                
                if rightIcon != nil {
                    Button {
                        
                    } label: {
                        HStack {
                            Text("Verify")
                                .font(.caption)
                                .hidden()
                            
                            Image(systemName: rightIcon ?? "person")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .aspectRatio(contentMode: .fit)
                                .tint(.black)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
            }
            Text(" " + placeHolderText + " ")
                .foregroundColor(Color.secondary)
                .background(Color(UIColor.systemBackground))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: textFieldHeight, trailing: 0))
            
        }
    }
}


#Preview {
    InitialView()
}
