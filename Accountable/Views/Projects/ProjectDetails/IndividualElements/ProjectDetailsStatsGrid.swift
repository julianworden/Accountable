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
        Grid(alignment: .center, horizontalSpacing: UiConstants.vStackSpacing, verticalSpacing: nil) {
            GridRow {
                ZStack {
                    CustomGroupBox()
                        .frame(height: abs((geo.size.width / 2) - UiConstants.vStackSpacing))

                    VStack {
                        Label {
                            Text(viewModel.totalHoursWorked)
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)
                        } icon: {
                            Image(systemName: "timer")
                                .foregroundColor(.purple)
                        }
                        .font(.title2.bold())

                        Text("Total Hours Worked (All Time)")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }

                ZStack {
                    CustomGroupBox()
                        .frame(height: abs((geo.size.width / 2) - UiConstants.vStackSpacing))

                    VStack {
                        Label {
                            Text(viewModel.averageHourWorkedPerSession)
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)
                        } icon: {
                            Image(systemName: "timer")
                                .foregroundColor(.purple)
                        }
                        .font(.title2.bold())

                        Text("Average Hours Worked Per Session")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
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
