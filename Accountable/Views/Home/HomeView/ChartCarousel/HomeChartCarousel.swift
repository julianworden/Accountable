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

                    if !viewModel.projectSessionsInPastWeek.isEmpty && !viewModel.userProjects.isEmpty {
                        VStack {
                            SectionTitle(text: "Time Worked This Past Week")

                            Chart {
                                ForEach(Weekday.allCases) { weekday in
                                    BarMark (
                                        x: .value("Weekday Name", weekday.matchesTodaysWeekday ? "Today" : weekday.abbreviated),
                                        y: .value("Total Hours", viewModel.getTotalLengthOfSessions(for: weekday))
                                    )
                                    .annotation {
                                        if viewModel.getTotalLengthOfSessions(for: weekday) != 0 {
                                            Text(viewModel.getTotalLengthOfSessions(for: weekday).secondsAsFullPeriodOfTimeString)
                                                .barMarkAnnotation()
                                        }
                                    }
                                }
                            }
                            .chartYAxis(.hidden)
                            .animation(.easeInOut, value: viewModel.projectSessionsInPastWeek)
                        }
                        .padding()
                    } else if viewModel.projectSessionsInPastWeek.isEmpty || viewModel.userProjects.isEmpty {
                        Text("You haven't worked on Accountable within the last week. Once you have session data from the last week, it will appear here in a chart.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding()
                .animation(.easeInOut, value: viewModel.projectSessionsInPastWeek)
            }
            .padding(.bottom, 40)

            ZStack {
                ZStack {
                    CustomGroupBox()

                    if !viewModel.userSessions.isEmpty {
                        VStack {
                            SectionTitle(text: "Hours Worked by Project")

                            Chart {
                                ForEach(viewModel.userProjects) { project in
                                    BarMark(
                                        x: .value("Project Name", project.name),
                                        y: .value("Number of Hours", project.totalSecondsPracticed)
                                    )
                                    .annotation {
                                        if project.totalSecondsPracticed > 0 {
                                            Text(project.totalSecondsPracticed.secondsAsHoursString)
                                                .barMarkAnnotation()
                                        }
                                    }
                                }
                            }
                            .chartYAxis(.hidden)
                            .animation(.easeInOut, value: viewModel.userSessions)
                        }
                        .padding()
                    } else if viewModel.userSessions.isEmpty {
                        Text("You haven't created any sessions on Acccountable. Once you have, you'll see your sessions sorted by project in a chart here.")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding()
                .animation(.easeInOut, value: viewModel.userSessions)
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
        HomeChartCarousel(viewModel: HomeViewModel(currentUser: User.example))
    }
}
