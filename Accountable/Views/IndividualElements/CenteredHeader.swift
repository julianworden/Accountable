//
//  CenteredHeader.swift
//  Accountable
//
//  Created by Julian Worden on 4/1/23.
//

import SwiftUI

struct CenteredHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 7) {
            Text(title)
                .font(.largeTitle.bold())

            Text(subtitle)
                .font(.title3)
                .multilineTextAlignment(.center)
        }
    }
}

struct OnboardingViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        CenteredHeader(title: "Sign Up", subtitle: "You'll need to create an account before you can use Accountable")
    }
}
