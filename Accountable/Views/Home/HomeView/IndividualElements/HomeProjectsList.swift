//
//  HomeProjectsList.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import SwiftUI

struct HomeProjectsList: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.userProjects) { project in
                NavigationLink {
                    ProjectDetailsView(project: project)
                } label: {
                    HomeViewProjectRow(project: project)
                }
                .tint(.primary)
            }
        }
        .padding(.top, -5)
    }
}

struct HomeProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        HomeProjectsList(viewModel: HomeViewModel(currentUser: User.example))
    }
}
