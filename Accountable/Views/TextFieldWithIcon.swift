//
//  TextFieldWithIcon.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import SwiftUI

struct TextFieldWithIcon: View {
    @FocusState var isFocused

    @Binding var text: String

    let iconName: String
    let placeholder: String
    let textFieldType: TextFieldType

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

                    if textFieldType == .password {
                        SecureField(placeholder, text: $text)
                            .focused($isFocused)

                    } else {
                        TextField(placeholder, text: $text)
                            .noAutoCapsOrCorrections()
                            .keyboardType(keyboardType)
                            .focused($isFocused)
                    }
                }

                RoundedRectangle(cornerRadius: 2)
                    .frame(height: 2)
                    .foregroundColor(.purple)
                    .opacity(isFocused ? 1.0 : 0.3)
                    .animation(.easeInOut(duration: 0.25), value: isFocused)
            }
        }
    }

    var keyboardType: UIKeyboardType {
        switch textFieldType {
        case .email:
            return .emailAddress
        case .numbers:
            return .numberPad
        default:
            return .default
        }
    }
}

struct TextFieldWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithIcon(text: .constant(""), iconName: "envelope", placeholder: "Email Address", textFieldType: .email)
    }
}
