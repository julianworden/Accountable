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
        } catch {
            if let error = AuthController.getAwsCognitoAuthError(from: error) {
                switch error {
                case .userNotConfirmed:
                    viewState = .error(message: ErrorMessageConstants.accountNotConfirmed)
                case .userNotFound:
                    viewState = .error(message: ErrorMessageConstants.accountDoesNotExist)
                default:
                    print(error)
                    viewState = .error(message: ErrorMessageConstants.unknown)
                }
            } else if let error = error as? AuthError {
                switch error {
                case .notAuthorized:
                    // Email is correct, password is not
                    viewState = .error(message: ErrorMessageConstants.incorrectPassword)
                default:
                    print(error)
                    viewState = .error(message: ErrorMessageConstants.unknown)
                }
            } else {
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
                    return
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
                    return
                }
            } else {
                print(error)
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
                    return
                }
            } else {
                print(error)
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        }
    }

    func postSignedInNotification() {
        NotificationCenter.default.post(name: .userLoggedIn, object: nil)
    }
}
