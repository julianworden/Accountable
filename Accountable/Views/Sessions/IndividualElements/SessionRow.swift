//
//  SessionRow.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import SwiftUI

struct SessionRow: View {
    let session: Session

    var body: some View {
        ZStack {
            CustomGroupBox()

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.durationInSeconds.secondsAsFullPeriodOfTime)
                    Text(session.unixDateAsDate.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                }
                .padding()

                Spacer()
            }
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        SessionRow(session: Session.example)
    }
}
