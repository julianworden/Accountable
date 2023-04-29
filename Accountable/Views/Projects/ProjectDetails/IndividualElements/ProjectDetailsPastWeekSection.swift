//
//  ProjectDetailsPastWeekSection.swift
//  Accountable
//
//  Created by Julian Worden on 4/10/23.
//

import SwiftUI

struct ProjectDetailsPastWeekSection: View {
    @ObservedObject var viewModel: ProjectDetailsViewModel

    var body: some View {
        ZStack {
            CustomGroupBox()

            VStack {
                if !viewModel.projectSessions.isEmpty {
                    VStack {
                        SectionTitle(text: "The Past Week")
                        ProjectDetailsSessionChart(viewModel: viewModel)
                    }
                    .padding()
                } else {
                    Text("You haven't created any sessions for this project. When you do, they will appear here in a chart.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
        .frame(height: UiConstants.primaryBoxHeight)
        .animation(.easeInOut, value: viewModel.projectSessions)
    }
}

struct ProjectDetailsPastWeekSection_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsPastWeekSection(viewModel: ProjectDetailsViewModel(project: Project.example))
    }
}
