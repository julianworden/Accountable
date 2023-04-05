//
//  ProjectDetailsView.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct ProjectDetailsView: View {
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

                    }
                    .buttonStyle(Primary())
                }
                .navigationTitle(viewModel.project.name)
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding(.horizontal)
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
