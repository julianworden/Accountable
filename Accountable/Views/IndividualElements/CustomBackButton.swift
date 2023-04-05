//
//  CustomBackButton.swift
//  Accountable
//
//  Created by Julian Worden on 4/4/23.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)
        }
        .padding()
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton()
    }
}
