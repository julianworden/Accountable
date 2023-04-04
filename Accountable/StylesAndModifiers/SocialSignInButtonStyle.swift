//
//  SocialSignInButtonStyle.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import SwiftUI

struct SocialSignIn: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 25, height: 25)
            .padding()
            .background(colorScheme == .light ? Color(uiColor: .systemGroupedBackground) : .gray.opacity(0.5))
            .cornerRadius(7)
    }
}
