//
//  CustomTextField.swift
//  Projeto-MC656
//
//  Created by Gab on 22/05/25.
//

import SwiftUI

struct CustomTextField: View {
    private let textFieldHeight: CGFloat = 50
    private let placeHolderText: String
    @Binding private var text: String
    @State private var isEditing = false
    @State var shouldBeSecure = false
    var keyboardType: UIKeyboardType = .default
    let rightIcon: String?

    private var shouldPlaceHolderMove: Bool {
        isEditing || (text.count != 0)
    }

    public init(
        placeHolder: String,
        text: Binding<String>,
        shouldBeSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        rightIcon: String? = nil
    ) {
        self._text = text
        self.placeHolderText = placeHolder
        self.shouldBeSecure = shouldBeSecure
        self.rightIcon = rightIcon
        self.keyboardType = keyboardType
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
                        .keyboardType(keyboardType)
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
