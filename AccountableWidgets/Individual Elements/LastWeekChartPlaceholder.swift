//
//  LastWeekChartPlaceholder.swift
//  AccountableWidgetsExtension
//
//  Created by Julian Worden on 4/26/23.
//

import Charts
import SwiftUI

struct LastWeekChartPlaceholder: View {
    var body: some View {
        VStack {
            SectionTitle(text: "Total Work (This Past Week)")

            Chart {
                ForEach(Array(Weekday.allCases.enumerated()), id: \.element) { index, weekday in
                    let placeholderHoursValue = PlaceholderData.sessionHours[index]

                    BarMark (
                        x: .value("Weekday Name", weekday.matchesTodaysWeekday ? "Today" : weekday.abbreviated),
                        y: .value("Total Hours", placeholderHoursValue)
                    )
                    .foregroundStyle(.purple)
                    .annotation {
                        Text(placeholderHoursValue.secondsAsFullPeriodOfTime)
                            .barMarkAnnotation()
                    }
                }
            }
            .chartYAxis(.hidden)
        }
        .padding()
    }
}

struct LastWeekChartPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        LastWeekChartPlaceholder()
    }
}
