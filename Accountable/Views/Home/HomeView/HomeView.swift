//
//  HomeView.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {

                case .dataLoading:
                    CustomProgressView()

                case .error, .dataLoaded:
                    ScrollView {
                        VStack(alignment: .leading, spacing: UiConstants.vStackSpacing) {
                            VStack {
                                SectionTitle(text: "At A Glance")

                                HomeCarouselView(viewModel: viewModel)
                            }

                            HomeProjectsHeader(viewModel: viewModel)

                            HomeProjectsList(viewModel: viewModel)
                        }
                        .padding(.horizontal)
                    }
                    .navigationTitle("Accountable")
                    .transition(.opacity)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Log Out") {
                                Task {
                                    await viewModel.logOut()
                                }
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
                await viewModel.printCurrentUserInfo()
                await viewModel.getLoggedInUserProjects()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
