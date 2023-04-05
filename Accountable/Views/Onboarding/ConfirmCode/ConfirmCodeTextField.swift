//
//  TextFieldWithLine.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import SwiftUI

struct ConfirmCodeTextField: View {
    @FocusState var isFocused

    @Binding var text: String

    let iconName: String
    let placeholder: String
    let isSecure: Bool

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.purple)
                        .frame(width: 18, height: 18)

                    Spacer()

                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .multilineTextAlignment(.center)
                }

                RoundedRectangle(cornerRadius: 2)
                    .fill(.purple)
                    .frame(height: 2)
                    .opacity(isFocused ? 1.0 : 0.3)
                    .animation(.easeInOut(duration: 2), value: isFocused)
            }
        }
        .frame(width: 75)
    }
}

struct ConfirmCodeTextField_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmCodeTextField(text: .constant(""), iconName: "envelope", placeholder: "Email Address", isSecure: true)
    }
}
