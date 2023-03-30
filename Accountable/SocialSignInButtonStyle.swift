//
//  SocialSignInButtonStyle.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import SwiftUI

struct SocialSignInButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 25, height: 25)
            .padding()
            .background(Color(uiColor: .systemGroupedBackground))
            .cornerRadius(7)
//            .shadow(color: .purple.opacity(0.2), radius: 5)
    }
}

extension View {
    func socialSignInButtonStyle() -> some View {
        modifier(SocialSignInButtonStyle())
    }
}
