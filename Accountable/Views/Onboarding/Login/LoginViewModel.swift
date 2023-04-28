//
//  LogInViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import Amplify
import AWSCognitoAuthPlugin
import Foundation
import Security
import WidgetKit

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var buttonsAreDisabled = false

    @Published var unverifiedAccountAlertIsShowing = false
    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .performingWork:
                buttonsAreDisabled = true
            case .workCompleted:
                buttonsAreDisabled = false
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
                buttonsAreDisabled = false
            default:
                errorMessageText = ErrorMessageConstants.invalidViewState
                errorMessageIsShowing = true
                buttonsAreDisabled = false
            }
        }
    }

    func signInWithEmailAndPassword() async {
        do {
            viewState = .performingWork
            let result = try await Amplify.Auth.signIn(username: emailAddress, password: password)
            if result.isSignedIn {
                let currentAuthUser = try await Amplify.Auth.getCurrentUser()
                let currentUser = try await DatabaseService.shared.getLoggedInUser()
                try await handleSignInNextStep(result.nextStep, forAuthUser: currentAuthUser)
                postSignedInNotification(forUser: currentUser)
                viewState = .workCompleted
            } else {
                try await handleSignInNextStep(result.nextStep, forAuthUser: nil)
            }
        } catch {
            handleSignInError(error)
        }
    }

    func sendConfirmationCode() async {
        do {
            viewState = .performingWork
            _ = try await Amplify.Auth.resendSignUpCode(for: emailAddress)
            postUserSignedUpNotification()
            viewState = .workCompleted
        } catch {
            print("ERROR: \(error) \(error.localizedDescription)")
            viewState = .error(message: error.localizedDescription)
        }
    }

    func currentAuthUserExistsInDataStore(_ authUser: AuthUser) async throws -> Bool {
        do {
            return try await DatabaseService.shared.authUserExistsInDataStore(authUser)
        } catch {
            throw error
        }
    }

    func addAuthUserToDataStore(_ authUser: AuthUser) async {
        do {
            let username = try await AuthService.shared.getLoggedInUserEmailAddress()
            let authUserAsUser = User(id: authUser.userId, username: username, isPremium: false)
            try await DatabaseService.shared.createOrUpdateUser(authUserAsUser)
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func handleSignInNextStep(
        _ nextStep: AuthSignInStep,
        forAuthUser authUser: AuthUser?
    ) async throws {
        do {
            switch nextStep {
            case .confirmSignUp(_):
                unverifiedAccountAlertIsShowing = true
            case .done:
                guard let authUser else { viewState = .error(message: ErrorMessageConstants.unknown); return }

                if try await !currentAuthUserExistsInDataStore(authUser) {
                    await addAuthUserToDataStore(authUser)
                }

                addUserToKeychain()
                await syncUserDataWithOnDeviceStorage()
                WidgetCenter.shared.reloadAllTimelines()
            default:
                print("Unknown next step: \(nextStep).")
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        } catch {
            throw DataStoreError.unknown(message: "Failed to complete sign in steps. \(ErrorMessageConstants.unknown)")
        }
    }

    func handleSignInError(_ error: Error) {
        if let error = AuthController.getAwsCognitoAuthError(from: error) {
            switch error {
            case .userNotFound:
                viewState = .error(message: ErrorMessageConstants.accountDoesNotExist)
            default:
                print("ERROR: \(error) \(error.localizedDescription)")
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        } else if let error = error as? AuthError {
            switch error {
            case .validation:
                // User did not enter an email address
                viewState = .error(message: ErrorMessageConstants.emptyOnboardingField)
            case .notAuthorized:
                // Email is correct, password is not
                viewState = .error(message: ErrorMessageConstants.incorrectPassword)

            default:
                print("ERROR: \(error) \(error.localizedDescription)")
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        } else {
            print(error)
            viewState = .error(message: error.localizedDescription)
        }
    }

    func addUserToKeychain() {
        let passwordAsData = password.data(using: String.Encoding.utf8)!

        let query: [String: Any] = [
            // Needs to be kSecClassInternetPassword to differentiate this from the login
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: emailAddress,
            kSecAttrAccessGroup as String: KeychainConstants.accessGroup,
            kSecValueData as String: passwordAsData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess || status == errSecDuplicateItem else {
            print(String(describing: SecCopyErrorMessageString(status, nil)))
            viewState = .error(message: KeychainError.unhandledError(status: status).localizedDescription)
            return
        }
    }

    func syncUserDataWithOnDeviceStorage() async {
        do {
            let userProjects = try await DatabaseService.shared.getAllLoggedInUserProjects()
            var userSessions = [Session]()
            for project in userProjects {
                if let projectSessions = project.sessions {
                    try await project.sessions?.fetch()
                    let userSessionsAsArray = projectSessions.map { $0 }
                    userSessions.append(contentsOf: userSessionsAsArray)
                }
            }

            try FileManagerController.shared.saveProjects(userProjects)
            try FileManagerController.shared.saveSessions(userSessions)
        } catch {

        }
    }

    func postSignedInNotification(forUser user: User) {
        NotificationCenter.default.post(name: .userLoggedIn, object: nil, userInfo: [NotificationConstants.currentUser: user])
    }

    func postUserSignedUpNotification() {
        NotificationCenter.default.post(
            name: .userSignedUp,
            object: nil,
            userInfo: [NotificationConstants.userEmailAddress: emailAddress]
        )
    }
}
