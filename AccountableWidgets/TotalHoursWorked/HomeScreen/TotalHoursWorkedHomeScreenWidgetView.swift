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

struct TotalHoursWorkedHomeScreenWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
            VStack {
                Label {
                    Text(entry.totalHoursWorkedAcrossAllProjectsAsString)
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

struct TotalHoursWorkedHomeScreenWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TotalHoursWorkedHomeScreenWidgetView(entry: SimpleEntry(date: Date.now, userProjects: [], userSessions: [], isForPlaceholder: false))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
