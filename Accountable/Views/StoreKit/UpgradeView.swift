//
//  UpgradeView.swift
//  Accountable
//
//  Created by Julian Worden on 4/28/23.
//

import SwiftUI

struct UpgradeView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = UpgradeViewModel()

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
    }
}

struct UpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView()
    }
}
