//
//  LoginController.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import Amplify
import Foundation

@MainActor
class LoginController: ObservableObject {
    @Published var loginStatus = LoginStatus.notDetermined

    @Published var errorMessageShowing = false
    var errorMessageText = ""

    init() {
        addUserLoggedInObserver()
    }

    func determineLoginStatus() async {
        do {
            try await Task.sleep(seconds: 2)
            _ = try await Amplify.Auth.getCurrentUser()
            loginStatus = .loggedIn
        } catch AuthError.signedOut {
            loginStatus = .loggedOut
        } catch {
            loginStatus = .error
            errorMessageText = error.localizedDescription
            errorMessageShowing = true
        }
    }

    func addUserLoggedInObserver() {
        NotificationCenter.default.addObserver(forName: .userLoggedIn, object: nil, queue: nil) { _ in
            Task { @MainActor in
                self.loginStatus = .loggedIn
            }
        }
    }
}
