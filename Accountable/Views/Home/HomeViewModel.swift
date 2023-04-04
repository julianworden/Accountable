//
//  HomeViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Amplify
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var addEditProjectSheetIsShowing = false

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
            default:
                errorMessageText = ErrorMessageConstants.invalidViewState
                errorMessageIsShowing = true
            }
        }
    }

    func logOut() async {
        _ = await Amplify.Auth.signOut()
        postLoggedOutNotification()
    }

    func printCurrentUserInfo() async {
        do {
            let currentUser = try await Amplify.Auth.getCurrentUser()
            print("CURRENT USER: \(currentUser)")
            let currentUserAttributes = try await Amplify.Auth.fetchUserAttributes()
            print("CURRENT USER ATTRIBUTES: \(currentUserAttributes)")
        } catch {
            print(error)
        }
    }

    func postLoggedOutNotification() {
        NotificationCenter.default.post(name: .userLoggedOut, object: nil)
    }
}
