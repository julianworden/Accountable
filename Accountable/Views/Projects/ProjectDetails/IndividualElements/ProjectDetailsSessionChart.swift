//
//  ProjectDetailsSessionChart.swift
//  Accountable
//
//  Created by Julian Worden on 4/10/23.
//

import Charts
import SwiftUI

struct ProjectDetailsSessionChart: View {
    @ObservedObject var viewModel: ProjectDetailsViewModel

    var body: some View {
        Chart {
            ForEach(Weekday.allCases) { weekday in
                BarMark (
                    x: .value("Weekday Name", weekday.matchesTodaysWeekday ? "Today" : weekday.abbreviated),
                    y: .value("Total Hours", viewModel.getTotalLengthOfSessions(for: weekday))
                )
                .annotation {
                    if viewModel.getTotalLengthOfSessions(for: weekday) != 0 {
                        Text(viewModel.getTotalLengthOfSessions(for: weekday).secondsAsFullPeriodOfTime)
                            .barMarkAnnotation()
                    }
                }
            }
        }
        .chartYAxis(.hidden)
//        .animation(.easeInOut, value: viewModel.projectSessionsInPastWeek)
    }
}

struct ProjectDetailsSessionChart_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsSessionChart(viewModel: ProjectDetailsViewModel(project: Project.example))
    }
}
