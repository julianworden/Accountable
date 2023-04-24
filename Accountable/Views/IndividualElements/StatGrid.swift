//
//  StatGrid.swift
//  Accountable
//
//  Created by Julian Worden on 4/11/23.
//

import SwiftUI

struct StatGrid<Content: View>: View {
    let alignment: Alignment
    let horizontalSpacing: CGFloat

    @ViewBuilder var statBoxes: () -> Content

    init(alignment: Alignment = .center, horizontalSpacing: CGFloat = UiConstants.vStackSpacing, @ViewBuilder statBoxes: @escaping () -> Content) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.statBoxes = statBoxes
    }

    var body: some View {
        Grid(alignment: alignment, horizontalSpacing: horizontalSpacing) {
            GridRow(content: statBoxes)
        }
    }
}

struct StatGrid_Previews: PreviewProvider {
    static var previews: some View {
        StatGrid(alignment: .center, horizontalSpacing: UiConstants.vStackSpacing) {
            Text("Example")
        }
    }
}
