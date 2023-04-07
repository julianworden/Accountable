//
//  ProjectDetailsView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct ProjectDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: ProjectDetailsViewModel

    init(project: Project) {
        _viewModel = StateObject(wrappedValue: ProjectDetailsViewModel(project: project))
    }

    var body: some View {
        ScrollView {
            GeometryReader { geo in
                VStack(spacing: UiConstants.vStackSpacing) {
                    VStack {
                        SectionTitle(text: "This Week")

                        CustomGroupBox()
                            .frame(height: UiConstants.primaryBoxHeight)
                    }

                    Grid(alignment: .center, horizontalSpacing: UiConstants.vStackSpacing, verticalSpacing: nil) {
                        GridRow {
                            CustomGroupBox()
                                .frame(height: abs((geo.size.width / 2) - 25))

                            CustomGroupBox()
                                .frame(height: abs((geo.size.width / 2) - 25))
                        }
                    }

                    SectionTitle(text: "Recent Sessions")

                    Button("Start Session") {
                        viewModel.sessionViewIsShowing.toggle()
                    }
                    .buttonStyle(Primary())
                    .sheet(isPresented: $viewModel.sessionViewIsShowing) {
                        SessionView(project: viewModel.project)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
                }
                .navigationTitle(viewModel.project.name)
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding(.horizontal)
        }
        .toolbar {
            Button {
                Task {
                    await viewModel.deleteProject()
                }
            } label: {
                Image(systemName: "trash")
            }
        }
        .onChange(of: viewModel.projectWasDeleted) { projectWasDeleted in
            if projectWasDeleted {
                dismiss()
            }
        }
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
