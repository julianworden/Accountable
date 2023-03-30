//
//  CustomDivider.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.secondary)
            .opacity(0.3)
    }
}

struct CustomDivider___Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider()
    }
}
