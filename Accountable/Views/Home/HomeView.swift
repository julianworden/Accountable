//
//  HomeView.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.defaultMinListRowHeight) var minListRowHeight

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {

                case .dataLoading:
                    ProgressView()
                        .transition(.opacity)

                case .error, .dataLoaded:
                    GeometryReader { geo in
                        ScrollView {
                            VStack(alignment: .leading, spacing: UiConstants.vStackSpacing) {
                                SectionTitle(text: "At A Glance")

                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(colorScheme == .light ? .white : .lightGray)
                                        .shadow(color: .purple.opacity(0.25), radius: 5)

                                    Text("You haven't worked on Accountable yet. When you do, you'll see your hours here.")
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                .frame(height: geo.size.height / 3)

                                HStack {
                                    SectionTitle(text: "Your Projects")
                                    Spacer()
                                    Button("Create a Project") {
                                        viewModel.addEditProjectSheetIsShowing.toggle()
                                    }
                                    .sheet(
                                        isPresented: $viewModel.addEditProjectSheetIsShowing,
                                        onDismiss: {
                                            Task {
                                                await viewModel.getLoggedInUserProjects()
                                            }
                                        },
                                        content: {
                                            AddEditProjectView()
                                        }
                                    )
                                }

                                ForEach(viewModel.userProjects) { project in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(colorScheme == .light ? .white : .lightGray)
                                            .shadow(color: .purple.opacity(0.25), radius: 5)

                                        Text(project.name)
                                    }
                                    .listRowSeparator(.hidden)
                                    .frame(height: minListRowHeight + 20)
                                }
                            }
                            .padding(.horizontal)
                        }
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
            .animation(.easeInOut, value: viewModel.viewState)
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
