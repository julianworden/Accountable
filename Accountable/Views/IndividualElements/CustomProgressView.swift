//
//  CustomProgressView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        VStack(spacing: 5) {
            ProgressView()
            Text("Fetching data.")
                .font(.caption)
                .italic()
                .foregroundColor(.secondary)
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
