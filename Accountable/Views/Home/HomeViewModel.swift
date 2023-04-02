//
//  HomeViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Amplify
import Foundation

class HomeViewModel: ObservableObject {
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

    func postLoggedOutNotification() {
        NotificationCenter.default.post(name: .userLoggedOut, object: nil)
    }
}
