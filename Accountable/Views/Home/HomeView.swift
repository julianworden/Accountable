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
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: UiConstants.vStackSpacing) {
                        SectionTitle(text: "At A Glance")

                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .shadow(color: .purple.opacity(0.25), radius: 5)

                            Text("You haven't worked on Accountable yet. When you do, you'll see your hours here.")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(height: geo.size.height / 3)

                        HStack {
                            SectionTitle(text: "Your Projects")
                            Spacer()
                            Button("Create a Project") {
                                viewModel.addEditProjectSheetIsShowing.toggle()
                            }
                            .sheet(isPresented: $viewModel.addEditProjectSheetIsShowing) {
                                AddEditProjectView()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Accountable")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        Task {
                            await viewModel.logOut()
                        }
                    }
                }
            }
            .task {
                await viewModel.printCurrentUserInfo()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
