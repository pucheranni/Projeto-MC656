//
//  CustomButton.swift
//  Projeto-MC656
//
//  Created by Gab on 22/05/25.
//

import SwiftUI

protocol CustomButtonDelegate: AnyObject {
    var isLoading: Bool { get }
}

struct CustomButton: View {
    var title: String
    weak var delegate: CustomButtonDelegate?
    var action: (() async -> Void)

    var body: some View {
        Button(
            action: {
                Task {
                    await action()
                }
            },
            label: {
                if delegate?.isLoading == true {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .colorInvert()
                }
            }
        )
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
}
