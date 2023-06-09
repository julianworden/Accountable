//
//  LastWeekChartWidget.swift
//  LastWeekChartWidget
//
//  Created by Julian Worden on 4/12/23.
//

import Amplify
import Charts
import SwiftUI
import WidgetKit

struct LastWeekChartWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        if !entry.isForPlaceholder {
            if !entry.projectSessionsInPastSixDays.isEmpty {
                VStack {
                    SectionTitle(text: "Total Work (This Past Week)")

                    Chart {
                        ForEach(Weekday.allCases) { weekday in
                            BarMark (
                                x: .value("Weekday Name", weekday.matchesTodaysWeekday ? "Today" : weekday.abbreviated),
                                y: .value("Total Hours", entry.getTotalLengthOfSessionsInPastSixDays(for: weekday))
                            )
                            .foregroundStyle(.purple)
                            .annotation {
                                let totalLengthOfSessionsForWeekday = entry.getTotalLengthOfSessionsInPastSixDays(for: weekday)

                                if totalLengthOfSessionsForWeekday != 0 {
                                    Text(totalLengthOfSessionsForWeekday.secondsAsFullPeriodOfTimeString)
                                        .barMarkAnnotation()
                                }
                            }
                        }
                    }
                    .chartYAxis(.hidden)
                }
                .padding()
            } else if entry.projectSessionsInPastSixDays.isEmpty {
                Text("You haven't worked on Accountable within the last week. Once you have session data from the last week, it will appear here in a chart.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        } else if entry.isForPlaceholder {
            LastWeekChartPlaceholder()
        }
    }
}

struct LastWeekChartWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        LastWeekChartWidgetView(entry: SimpleEntry(date: Date.now, userProjects: [], userSessions: [], isForPlaceholder: false))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
