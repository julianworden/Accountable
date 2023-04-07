//
//  LogInViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import Amplify
import AWSCognitoAuthPlugin
import Foundation

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
                try await handleSignInNextStep(result.nextStep, forAuthUser: currentAuthUser)
                postSignedInNotification()
                viewState = .workCompleted
            } else {
                try await handleSignInNextStep(result.nextStep, forAuthUser: nil)
            }
        } catch {
            handleSignInError(error)
        }
    }

    func signInWithApple() async {
        do {
            viewState = .performingWork
            let signInResult = try await Amplify.Auth.signInWithWebUI(for: .apple)
            if signInResult.isSignedIn {
                let currentAuthUser = try await Amplify.Auth.getCurrentUser()
                try await handleSignInNextStep(signInResult.nextStep, forAuthUser: currentAuthUser, externalProvider: .apple)
                postSignedInNotification()
                viewState = .workCompleted
            }
        } catch {
            handleSignInError(error)
        }
    }

    func signInWithGoogle() async {
        do {
            viewState = .performingWork
            let signInResult = try await Amplify.Auth.signInWithWebUI(for: .google)
            if signInResult.isSignedIn {
                let currentAuthUser = try await Amplify.Auth.getCurrentUser()
                try await handleSignInNextStep(signInResult.nextStep, forAuthUser: currentAuthUser, externalProvider: .google)
                postSignedInNotification()
                viewState = .workCompleted
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

    func addAuthUserToDataStore(_ authUser: AuthUser, externalProvider: ExternalProvider?) async {
        do {
            let username = try await AuthService.shared.getLoggedInUserEmailAddress()
            let authUserAsUser = User(id: authUser.userId, username: username, externalProvider: externalProvider)
            try await DatabaseService.shared.createOrUpdateUser(authUserAsUser)
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func handleSignInNextStep(
        _ nextStep: AuthSignInStep,
        forAuthUser authUser: AuthUser?,
        externalProvider: ExternalProvider? = nil
    ) async throws {
        do {
            switch nextStep {
            case .confirmSignUp(_):
                unverifiedAccountAlertIsShowing = true
            case .done:
                guard let authUser else { viewState = .error(message: ErrorMessageConstants.unknown); return }

                if try await currentAuthUserExistsInDataStore(authUser) {
                    return
                } else {
                    await addAuthUserToDataStore(authUser, externalProvider: externalProvider)
                    return
                }
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

    func postSignedInNotification() {
        NotificationCenter.default.post(name: .userLoggedIn, object: nil)
    }

    func postUserSignedUpNotification() {
        NotificationCenter.default.post(
            name: .userSignedUp,
            object: nil,
            userInfo: [NotificationConstants.userEmailAddress: emailAddress]
        )
    }
}
