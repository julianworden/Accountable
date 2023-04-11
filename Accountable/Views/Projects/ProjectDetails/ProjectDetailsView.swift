//
//  ProjectDetailsView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct ProjectDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var ongoingSessionController: OngoingSessionController

    @StateObject var viewModel: ProjectDetailsViewModel

    init(project: Project) {
        _viewModel = StateObject(wrappedValue: ProjectDetailsViewModel(project: project))
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: UiConstants.vStackSpacing) {
                    if ongoingSessionController.sessionIsActive {
                        OngoingSessionTitleAndBox()
                    }

                    ProjectDetailsPastWeekSection(viewModel: viewModel)

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
                                    .font(.title.bold())

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
                                    .font(.title.bold())

                                    Text("Average Hours Worked Per Session")
                                        .font(.title3)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                            }
                        }
                    }

                    FirstThreeProjectSessionsHeader(viewModel: viewModel)

                    FirstThreeProjectSessionsList(viewModel: viewModel)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(viewModel.project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(role: ongoingSessionController.sessionIsActive ? .destructive : nil) {
                    viewModel.sessionViewIsShowing.toggle()
                } label: {
                    Image(systemName: ongoingSessionController.primaryTimerButtonIconName)
                }
                .sheet(isPresented: $viewModel.sessionViewIsShowing) {
                    SessionView(project: viewModel.project)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }

                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteProject()
                    }
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .alert(
            "Error",
            isPresented: $viewModel.errorMessageIsShowing,
            actions: { Button("OK") { } },
            message: { Text(viewModel.errorMessageText) }
        )
        .onChange(of: viewModel.projectWasDeleted) { projectWasDeleted in
            if projectWasDeleted {
                dismiss()
            }
        }
        .task {
            await viewModel.getProjectSessions()
            await viewModel.subscribeToProject()
            viewModel.addNewSessionCreatedObserver()
        }
        .onDisappear {
            viewModel.unsubscribeFromProject()
            viewModel.removeNewSessionCreatedObserver()
        }
        .animation(.easeInOut, value: ongoingSessionController.sessionIsActive)
    }
}

struct ProjectDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProjectDetailsView(project: Project.example)
                .navigationTitle("Learn to Code")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
