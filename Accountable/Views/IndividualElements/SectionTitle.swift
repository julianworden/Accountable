//
//  SectionTitle.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import SwiftUI

struct SectionTitle: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .font(.title3.bold())
            Spacer()
        }
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle(text: "At A Glance")
    }
}
