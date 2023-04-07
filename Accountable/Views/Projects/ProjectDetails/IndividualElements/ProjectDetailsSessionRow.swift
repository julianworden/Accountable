//
//  ProjectDetailsSessionRow.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import SwiftUI

struct ProjectDetailsSessionRow: View {
    let session: Session

    var body: some View {
        ZStack {
            CustomGroupBox()

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.durationInSeconds.secondsAsPeriodOfTime)
                    Text(session.unixDateAsDate.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                }
                .padding()

                Spacer()
            }
        }
    }
}

struct ProjectDetailsSessionRow_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsSessionRow(session: Session.example)
    }
}
