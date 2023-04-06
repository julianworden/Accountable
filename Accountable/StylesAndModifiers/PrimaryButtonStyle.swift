//
//  PrimaryButton.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import Foundation
import SwiftUI

struct Primary: ButtonStyle {
    let backgroundColor: Color

    init(backgroundColor: Color = .accentColor) {
        self.backgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            .background(backgroundColor)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut.speed(2), value: configuration.isPressed)
    }
}

struct Primary_Previews: PreviewProvider {
    static var previews: some View {
        Button("Hello") {

        }
        .buttonStyle(Primary(backgroundColor: .purple))
        .padding()
    }
}
