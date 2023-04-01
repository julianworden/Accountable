//
//  NoAutoCapsOrCorrections.swift
//  Accountable
//
//  Created by Julian Worden on 4/1/23.
//

import Foundation
import SwiftUI

struct NoAutoCapsOrCorrections: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

extension View {
    func noAutoCapsOrCorrections() -> some View {
        self.modifier(NoAutoCapsOrCorrections())
    }
}
