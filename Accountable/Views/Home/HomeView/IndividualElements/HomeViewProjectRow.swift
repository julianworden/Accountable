//
//  HomeViewProjectRow.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct HomeViewProjectRow: View {
    @Environment(\.colorScheme) var colorScheme

    let project: Project

    var body: some View {
        ZStack {
            CustomGroupBox()

            VStack(alignment: .leading) {
                HStack {
                    Text(project.name)
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct HomeViewProjectRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewProjectRow(project: Project.example)
    }
}
