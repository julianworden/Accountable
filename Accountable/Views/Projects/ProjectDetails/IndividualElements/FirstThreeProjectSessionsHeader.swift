//
//  FirstThreeProjectSessionsHeader.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import SwiftUI

struct FirstThreeProjectSessionsHeader: View {
    @ObservedObject var viewModel: ProjectDetailsViewModel

    var body: some View {
        HStack {
            SectionTitle(text: "Recent Sessions")

            NavigationLink {
                AllSessionsView(sessions: viewModel.projectSessions)
            } label: {
                Text("Edit")
            }
        }
    }
}

struct FirstThreeProjectSessionsHeader_Previews: PreviewProvider {
    static var previews: some View {
        FirstThreeProjectSessionsHeader(viewModel: ProjectDetailsViewModel(project: Project.example))
    }
}
