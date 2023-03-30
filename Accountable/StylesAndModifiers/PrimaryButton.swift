//
//  PrimaryButton.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import Foundation
import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            .background(.purple)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}