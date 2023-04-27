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

struct TotalHoursWorkedLockScreenWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            Text(entry.totalHoursWorkedAcrossAllProjectsAsString)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

struct TotalHoursWorkedLockScreenWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TotalHoursWorkedLockScreenWidgetView(entry: SimpleEntry(date: Date.now, userProjects: PlaceholderData.projects, userSessions: [], isForPlaceholder: false))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
