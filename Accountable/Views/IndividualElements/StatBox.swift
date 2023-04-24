//
//  StatBox.swift
//  Accountable
//
//  Created by Julian Worden on 4/11/23.
//

import SwiftUI

struct StatBox: View {
    let title: String
    let subtitle: String
    let iconName: String
    let geo: GeometryProxy

    var body: some View {
        ZStack {
            CustomGroupBox()
                .frame(height: abs((geo.size.width / 2) - UiConstants.vStackSpacing))

            VStack {
                Label {
                    Text(title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                } icon: {
                    Image(systemName: iconName)
                        .foregroundColor(.purple)
                }
                .font(.title2.bold())

                Text(subtitle)
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

struct StatBox_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            StatBox(title: "0h", subtitle: "Total Hours Worked (All Time)", iconName: "timer", geo: geo)
        }
    }
}
