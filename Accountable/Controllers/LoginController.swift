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
        addUserLoggedOutObserver()
    }

    func determineLoginStatus() async {
        do {
            try await Task.sleep(seconds: 2)
            let result = try await Amplify.Auth.fetchAuthSession()
            if result.isSignedIn {
                let currentUser = try await DatabaseService.shared.getLoggedInUser()
                loginStatus = .loggedIn(currentUser: currentUser)
            } else {
                loginStatus = .loggedOut
            }
        } catch {
            loginStatus = .error(message: error.localizedDescription)
            errorMessageText = error.localizedDescription
            errorMessageShowing = true
        }
    }

    func addUserLoggedInObserver() {
        NotificationCenter.default.addObserver(forName: .userLoggedIn, object: nil, queue: nil) { notification in
            if let currentUser = notification.userInfo?[NotificationConstants.currentUser] as? User {
                Task { @MainActor in
                    self.loginStatus = .loggedIn(currentUser: currentUser)
                }
            }
        }
    }

    func addUserLoggedOutObserver() {
        NotificationCenter.default.addObserver(forName: .userLoggedOut, object: nil, queue: nil) { _ in
            Task { @MainActor in
                self.loginStatus = .loggedOut
            }
        }
    }
}
