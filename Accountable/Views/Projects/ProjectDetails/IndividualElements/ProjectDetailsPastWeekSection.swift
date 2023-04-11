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
                SectionTitle(text: "The Past Week")
                ProjectDetailsSessionChart(viewModel: viewModel)
            }
            .padding()
        }
        .frame(height: UiConstants.primaryBoxHeight)
    }
}

struct ProjectDetailsPastWeekSection_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsPastWeekSection(viewModel: ProjectDetailsViewModel(project: Project.example))
    }
}
