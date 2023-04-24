//
//  HomeChartCarousel.swift
//  Accountable
//
//  Created by Julian Worden on 4/11/23.
//

import Charts
import SwiftUI

struct HomeChartCarousel: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        TabView {
            ZStack {
                ZStack {
                    CustomGroupBox()

                    VStack {
                        SectionTitle(text: "Hours Worked by Project")

                        Chart {
                            ForEach(viewModel.userProjects) { project in
                                if project.totalSecondsPracticed > 0 {
                                    BarMark(
                                        x: .value("Project Name", project.name),
                                        y: .value("Number of Hours", project.totalSecondsPracticed)
                                    )
                                    .annotation {
                                        Text(project.totalSecondsPracticed.secondsAsHours)
                                            .barMarkAnnotation()
                                    }
                                }
                            }
                        }
                        .chartYAxis(.hidden)
                        .animation(.easeInOut, value: viewModel.userProjects)
                    }
                    .padding()
                }
                .padding()
            }
            .padding(.bottom, 40)

            ZStack {
                ZStack {
                    CustomGroupBox()

                    VStack {
                        SectionTitle(text: "Hours Worked This Past Week")

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
                        .animation(.easeInOut, value: viewModel.projectSessionsInPastWeek)
                    }
                    .padding()
                }
                .padding()
            }
            .padding(.bottom, 40)

        }
        .frame(height: 400)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct HomeChartCarousel_Previews: PreviewProvider {
    static var previews: some View {
        HomeChartCarousel(viewModel: HomeViewModel())
    }
}
