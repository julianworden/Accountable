//
//  BarMarkAnnotationTextStyle.swift
//  Accountable
//
//  Created by Julian Worden on 4/11/23.
//

import SwiftUI

struct BarMarkAnnotation: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .multilineTextAlignment(.center)
            .frame(width: 30)
    }
}

extension View {
    func barMarkAnnotation() -> some View {
        self
            .modifier(BarMarkAnnotation())
    }
}
