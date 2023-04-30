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
                            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)).combined(with: .opacity))
                            .onAppear {
                                withAnimation(.easeInOut) {
                                    viewModel.startNewSessionButtonIsShowing = false
                                }
                            }
                            .onDisappear {
                                withAnimation(.easeInOut) {
                                    viewModel.startNewSessionButtonIsShowing = true
                                }
                            }
                    }

                    ProjectDetailsPastWeekSection(viewModel: viewModel)

                    ProjectDetailsStatsGrid(viewModel: viewModel, geo: geo)

                    if viewModel.startNewSessionButtonIsShowing {
                        Button {
                            viewModel.sessionViewIsShowing.toggle()
                        } label: {
                            Label("Start New Session", systemImage: "play")
                        }
                        .buttonStyle(Primary())
                        .transition(.opacity)
                    }

                    FirstThreeProjectSessionsHeader(viewModel: viewModel)
                        .animation(.easeInOut, value: viewModel.projectSessions)

                    // Without this VStack, animation will behave unexpectedly when session is ended
                    VStack {
                        if !viewModel.projectSessions.isEmpty {
                            FirstThreeProjectSessionsList(viewModel: viewModel)
                        } else {
                            Text("You haven't created any sessions for this project yet. When you do, they will appear here.")
                                .multilineTextAlignment(.center)
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut, value: viewModel.projectSessions)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(viewModel.project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(role: .destructive) {
                viewModel.deleteProjectConfirmationAlertIsShowing.toggle()
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
            .alert(
                "Are You Sure?",
                isPresented: $viewModel.deleteProjectConfirmationAlertIsShowing,
                actions: {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete Project", role: .destructive) {
                        Task {
                            await viewModel.deleteProject()
                        }
                    }
                },
                message: { Text("Deleting this project will also delete all of its sessions. This cannot be undone.") }
            )
        }
        .alert(
            "Error",
            isPresented: $viewModel.errorMessageIsShowing,
            actions: { Button("OK") { } },
            message: { Text(viewModel.errorMessageText) }
        )
        .sheet(isPresented: $viewModel.sessionViewIsShowing) {
            StartStopSessionView(project: viewModel.project)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
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
