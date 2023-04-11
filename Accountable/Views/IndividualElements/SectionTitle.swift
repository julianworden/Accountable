//
//  SectionTitle.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import SwiftUI

struct SectionTitle: View {
    let text: String
    let font: Font

    init(text: String, font: Font = .title3.bold()) {
        self.text = text
        self.font = font
    }

    var body: some View {
        HStack {
            Text(text)
                .font(font)
            Spacer()
        }
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle(text: "At A Glance")
    }
}
