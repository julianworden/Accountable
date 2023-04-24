//
//  ProjectDetailsStatsGrid.swift
//  Accountable
//
//  Created by Julian Worden on 4/10/23.
//

import SwiftUI

struct ProjectDetailsStatsGrid: View {
    @ObservedObject var viewModel: ProjectDetailsViewModel

    let geo: GeometryProxy

    var body: some View {
        StatGrid {
            GridRow {
                StatBox(title: viewModel.totalHoursWorked, subtitle: "Total Hours Worked (All Time)", iconName: "timer", geo: geo)

                StatBox(title: viewModel.averageHourWorkedPerSession, subtitle: "Average Hours Worked Per Session", iconName: "timer", geo: geo)
            }
        }
    }
}

struct ProjectDetailsStatsGrid_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ProjectDetailsStatsGrid(viewModel: ProjectDetailsViewModel(project: Project.example), geo: geo)
        }
    }
}
