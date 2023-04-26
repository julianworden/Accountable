//
//  TotalHoursWorkedWidgetView.swift
//  LastWeekChartWidget
//
//  Created by Julian Worden on 4/26/23.
//

import Amplify
import Charts
import SwiftUI
import WidgetKit

struct TotalHoursWorkedWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        if let errorMessage = entry.errorMessage {
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .padding()
        } else {
            VStack {
                Label {
                    Text(entry.totalHoursWorkedAcrossAllProjects)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                } icon: {
                    Image(systemName: "timer")
                        .foregroundColor(.purple)
                }
                .font(.title2.bold())

                Text("Total Hours Worked")
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }

    }
}

struct TotalHoursWorkedWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        LastWeekChartWidgetView(entry: SimpleEntry(date: Date.now, userProjects: [], userSessions: [], isForPlaceholder: false))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
