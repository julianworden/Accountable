//
//  HomeView.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack {

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        Task {
                            await viewModel.logOut()
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
