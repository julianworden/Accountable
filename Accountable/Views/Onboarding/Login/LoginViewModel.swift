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
                postSignedInNotification()
                viewState = .workCompleted
            }

            switch result.nextStep {
            case .confirmSignUp(_):
                unverifiedAccountAlertIsShowing = true
            case .done:
                return
            default:
                print("Unknown next step: \(result.nextStep).")
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        } catch {
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
                case .notAuthorized:
                    // Email is correct, password is not
                    viewState = .error(message: ErrorMessageConstants.incorrectPassword)
                default:
                    print("ERROR: \(error) \(error.localizedDescription)")
                    viewState = .error(message: ErrorMessageConstants.unknown)
                }
            } else {
                print(error)
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        }
    }

    func signInWithApple() async {
        do {
            let signInResult = try await Amplify.Auth.signInWithWebUI(for: .apple)
            if signInResult.isSignedIn {
                postSignedInNotification()
            }
        } catch {
            if let error = AuthController.getAwsCognitoAuthError(from: error) {
                switch error {
                case .userCancelled:
                    return
                default:
                    print(error)
                    viewState = .error(message: error.localizedDescription)
                }
            } else {
                print(error)
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        }
    }

    func signInWithGoogle() async {
        do {
            let signInResult = try await Amplify.Auth.signInWithWebUI(for: .google)
            if signInResult.isSignedIn {
                postSignedInNotification()
            }
        } catch {
            if let error = AuthController.getAwsCognitoAuthError(from: error) {
                switch error {
                case .userCancelled:
                    return
                default:
                    print("ERROR: \(error) \(error.localizedDescription)")
                    viewState = .error(message: error.localizedDescription)
                }
            } else {
                print("ERROR: \(error) \(error.localizedDescription)")
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        }
    }

    func signInWithFacebook() async {
        do {
            let signInResult = try await Amplify.Auth.signInWithWebUI(for: .facebook)
            if signInResult.isSignedIn {
                postSignedInNotification()
            }
        } catch {
            if let error = AuthController.getAwsCognitoAuthError(from: error) {
                switch error {
                case .userCancelled:
                    return
                default:
                    print("ERROR: \(error) \(error.localizedDescription)")
                    viewState = .error(message: error.localizedDescription)
                }
            } else {
                print("ERROR: \(error) \(error.localizedDescription)")
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
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
