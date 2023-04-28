//
//  HomeView.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var ongoingSessionController: OngoingSessionController

    @StateObject private var viewModel: HomeViewModel

    init(currentUser: User) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(currentUser: currentUser))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {

                case .dataLoading:
                    CustomProgressView()

                case .error, .dataLoaded, .dataNotFound:
                    GeometryReader { geo in
                        ScrollView {
                            VStack(alignment: .leading, spacing: UiConstants.vStackSpacing) {
                                if ongoingSessionController.sessionIsActive {
                                    NavigationLink {
                                        // Force unwrap safe because NavigationLink isn't tappable unless projectForActiveSession != nil
                                        ProjectDetailsView(project: ongoingSessionController.projectForActiveSession!)
                                    } label: {
                                        OngoingSessionTitleAndBox()
                                    }
                                    .allowsHitTesting(ongoingSessionController.projectForActiveSession != nil)
                                    .padding(.horizontal)
                                }

                                HomeChartCarousel(viewModel: viewModel)

                                StatGrid {
                                    StatBox(title: viewModel.totalHoursWorked, subtitle: "Total Hours Worked", iconName: "timer", geo: geo)
                                    StatBox(title: viewModel.totalHoursWorked, subtitle: "Total Hours Worked", iconName: "timer", geo: geo)
                                }
                                .padding(.horizontal)

                                HomeProjectsHeader(viewModel: viewModel)
                                    .padding(.horizontal)

                                HomeProjectsList(viewModel: viewModel)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .navigationTitle("Accountable")
                    .transition(.opacity)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                if !viewModel.currentUser.isPremium {
                                    Button("Upgrade") {
                                        viewModel.upgradeSheetIsShowing = true
                                    }
                                }

                                Button("Log Out") {
                                    Task {
                                        await viewModel.logOut()
                                    }
                                }
                            } label: {
                                Image(systemName: "gear")
                            }
                            .fullScreenCover(isPresented: $viewModel.upgradeSheetIsShowing) {
                                NavigationStack {
                                    UpgradeView()
                                }
                            }
                        }
                    }
                    .onChange(of: ongoingSessionController.sessionIsActive) { sessionIsActive in
                        if !sessionIsActive {
                            Task {
                                await viewModel.getLoggedInUserProjectsAndSessions()
                            }
                        }
                    }

                default:
                    Text("Invalid viewState: \(String(describing: viewModel.viewState))")
                }
            }
            .alert(
                "Error",
                isPresented: $viewModel.errorMessageIsShowing,
                actions: { Button("OK") { } },
                message: { Text(viewModel.errorMessageText) }
            )
            .task {
                await viewModel.getLoggedInUserProjectsAndSessions()
//                try? FileManagerController.shared.deleteAllSessions()
            }
            .animation(.easeInOut, value: ongoingSessionController.sessionIsActive)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentUser: User.example)
            .environmentObject(OngoingSessionController())
    }
}
