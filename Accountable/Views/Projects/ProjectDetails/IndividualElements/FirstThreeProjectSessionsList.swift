//
//  FirstThreeProjectSessionsList.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import SwiftUI

struct FirstThreeProjectSessionsList: View {
    @ObservedObject var viewModel: ProjectDetailsViewModel

    var body: some View {
        ForEach(viewModel.projectSessions.prefix(3)) { session in
            ProjectDetailsSessionRow(session: session)
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

struct FirstThreeProjectSessionsList_Previews: PreviewProvider {
    static var previews: some View {
        FirstThreeProjectSessionsList(viewModel: ProjectDetailsViewModel(project: Project.example))
    }
}
