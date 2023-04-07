//
//  CustomGroupBox.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct CustomGroupBox: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(colorScheme == .light ? .white : .lightGray)
            .shadow(color: .purple.opacity(UiConstants.purpleShadowOpacity), radius: UiConstants.purpleShadowRadius)
    }
}

struct CustomGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        CustomGroupBox()
    }
}
