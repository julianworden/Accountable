//
//  SocialSignInButtonStyle.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import SwiftUI

struct SocialSignIn: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 25, height: 25)
            .padding()
            .background(Color(uiColor: .systemGroupedBackground))
            .cornerRadius(7)
    }
}
