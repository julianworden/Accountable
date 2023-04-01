//
//  SignUpViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import Amplify
import AWSCognitoAuthPlugin
import Foundation

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var confirmedEmailAddress = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    @Published var userCreationWasSuccessful = false
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

    var emailAddressesAndPasswordsMatch: Bool {
        if emailAddress != confirmedEmailAddress {
            viewState = .error(message: ErrorMessageConstants.emailAddressesDontMatchOnSignUp)
            return false
        }

        if password != confirmedPassword {
            viewState = .error(message: ErrorMessageConstants.passwordsDontMatchOnSignUp)
            return false
        }

        return true
    }

    func signUpButtonTapped() async {
        guard emailAddressesAndPasswordsMatch else {
            return
        }

        do {
            viewState = .performingWork
            try await signUpUser()
            viewState = .workCompleted
        } catch {
            if let cognitoAuthError = AuthController.getAwsCognitoAuthError(from: error) {
                switch cognitoAuthError {
                case .usernameExists:
                    viewState = .error(message: ErrorMessageConstants.emailAddressAlreadyInUse)
                case .invalidParameter:
                    viewState = .error(message: ErrorMessageConstants.invalidEmailAddressOnSignUp)
                case .invalidPassword:
                    viewState = .error(message: ErrorMessageConstants.passwordTooShort)
                default:
                    print(error)
                    viewState = .error(message: ErrorMessageConstants.unknown)
                }
            } else {
                viewState = .error(message: error.localizedDescription)
            }
        }
    }

    func signUpUser() async throws {
        let userAttributes = [AuthUserAttribute(.email, value: emailAddress)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: emailAddress,
                password: password,
                options: options
            )

            switch signUpResult.nextStep {
            case .confirmUser:
                postUserSignedUpNotification()
                userCreationWasSuccessful = true
            default:
                viewState = .error(message: ErrorMessageConstants.unknown)
            }
        }
    }

    func postUserSignedUpNotification() {
        NotificationCenter.default.post(
            name: .userSignedUp,
            object: nil,
            userInfo: [NotificationConstants.userEmailAddress: emailAddress]
        )
    }
}
