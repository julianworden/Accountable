//
//  Color+CustomColors.swift
//  Accountable
//
//  Created by Julian Worden on 4/4/23.
//

import SwiftUI

extension Color {
    static var lightGray: Color {
        Self.gray.opacity(0.5)
    }

    static var textFieldPrompt: Color {
        Self.secondary.opacity(0.55)
    }
}

struct Color_CustomColors_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.lightGray
            Color.textFieldPrompt
        }
    }
}
