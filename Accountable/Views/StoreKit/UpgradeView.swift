//
//  UpgradeView.swift
//  Accountable
//
//  Created by Julian Worden on 4/28/23.
//

import SwiftUI

struct UpgradeView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: UpgradeViewModel

    init(currentUser: User) {
        _viewModel = StateObject(wrappedValue: UpgradeViewModel(currentUser: currentUser))
    }

    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .dataLoading:
                ProgressView()

            case .dataLoaded, .performingWork, .workCompleted:
                if let accountablePremium = viewModel.accountablePremium {
                    VStack {
                        CenteredHeader(
                            title: accountablePremium.displayName,
                            subtitle: "Upgrade to \(accountablePremium.description) for only \(accountablePremium.displayPrice)"
                        )

                        AsyncButton {
                            await viewModel.purchase(accountablePremium)
                        } label: {
                            Text("Buy Now")
                        }
                        .buttonStyle(Primary())
                        .disabled(viewModel.buttonsAreDisabled)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                dismiss()
                            }
                            .disabled(viewModel.buttonsAreDisabled)
                        }
                    }
                    .padding()
                }

            case .dataNotFound:
                Text(StoreKitError.noProductsFetched.localizedDescription)
                    .multilineTextAlignment(.center)
                    .padding()

            default:
                Text("Invalid ViewState: \(String(describing: viewModel.viewState))")
            }
        }
        .task {
            await viewModel.fetchAvailableProducts()
        }
        .onChange(of: viewModel.dismissView) { dismissView in
            if dismissView {
                dismiss()
            }
        }
    }
}

struct UpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView(currentUser: User.example)
    }
}
