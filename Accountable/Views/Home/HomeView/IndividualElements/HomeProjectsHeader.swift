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
                viewModel.addEditProjectSheetIsShowing.toggle()
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
        }
    }
}

struct HomeProjectSection_Previews: PreviewProvider {
    static var previews: some View {
        HomeProjectsHeader(viewModel: HomeViewModel(currentUser: User.example))
    }
}
