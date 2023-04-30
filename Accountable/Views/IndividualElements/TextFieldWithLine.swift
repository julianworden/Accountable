//
//  TextFieldWithIcon.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import SwiftUI

struct TextFieldWithLine: View {
    @FocusState var isFocused

    @Binding var text: String

    let iconName: String?
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool

    init(text: Binding<String>, iconName: String? = nil, placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool) {
        _text = Binding(projectedValue: text)
        self.iconName = iconName
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecure = isSecure
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if let iconName {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.purple)
                            .frame(width: 18, height: 18)

                        Spacer()
                    }

                    if isSecure {
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
}

struct TextFieldWithLine_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLine(text: .constant(""), iconName: "envelope", placeholder: "Email Address", keyboardType: .emailAddress, isSecure: false)
    }
}
