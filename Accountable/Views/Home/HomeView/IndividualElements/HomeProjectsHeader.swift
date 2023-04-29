//
//  HomeProjectSection.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct HomeProjectsHeader: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        HStack {
            SectionTitle(text: "Your Projects")
            Spacer()
            Button("Create a Project") {
                if viewModel.userCanCreateNewProject {
                    viewModel.addEditProjectSheetIsShowing.toggle()
                } else {
                    viewModel.upgradeNeededAlertIsShowing.toggle()
                }
            }
            .sheet(
                isPresented: $viewModel.addEditProjectSheetIsShowing,
                onDismiss: {
                    Task {
                        await viewModel.getLoggedInUserProjectsAndSessions()
                    }
                },
                content: {
                    AddEditProjectView()
                }
            )
            .alert(
                "Error",
                isPresented: $viewModel.upgradeNeededAlertIsShowing,
                actions: {
                    Button("Cancel", role: .cancel) { }
                    Button("Upgrade") { viewModel.upgradeSheetIsShowing.toggle() }
                },
                message: { Text("You're using the free version of Accountable, which means you can only create up to 3 projects. If you'd like to create more than 3 projects, you'll need to Upgrade to Accountable Premium.") }
            )
        }
    }
}

struct HomeProjectSection_Previews: PreviewProvider {
    static var previews: some View {
        HomeProjectsHeader(viewModel: HomeViewModel(currentUser: User.example))
    }
}
