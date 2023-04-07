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

            if viewModel.projectSessions.count > 3 {
                NavigationLink {
                    EmptyView()
                } label: {
                    Text("See All")
                }
            }
        }
    }
}

struct FirstThreeProjectSessionsHeader_Previews: PreviewProvider {
    static var previews: some View {
        FirstThreeProjectSessionsHeader(viewModel: ProjectDetailsViewModel(project: Project.example))
    }
}
