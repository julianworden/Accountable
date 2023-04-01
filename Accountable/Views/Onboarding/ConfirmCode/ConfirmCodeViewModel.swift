//
//  ConfirmCodeViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import Amplify
import Foundation

@MainActor
final class ConfirmCodeViewModel: ObservableObject {
    @Published var verificationCode = ""
    let emailAddress: String?
    @Published var buttonsAreDisabled = false

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    init(emailAddress: String?) {
        self.emailAddress = emailAddress
    }

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

    func verifyButtonTapped() async {
        guard verificationCodeIsValid else {
            return
        }

        guard let emailAddress else {
            viewState = .error(message: ErrorMessageConstants.unknown)
            return
        }

        do {
            viewState = .performingWork
            let result = try await Amplify.Auth.confirmSignUp(for: emailAddress, confirmationCode: verificationCode)
            if result.isSignUpComplete {
                postAccountConfirmedNotification()
                viewState = .workCompleted
            }
        } catch {
            print(error)
            if let cognitoAuthError = AuthController.getAwsCognitoAuthError(from: error) {
                switch cognitoAuthError {
                case .codeMismatch:
                    viewState = .error(message: ErrorMessageConstants.incorrectConfirmationCode)
                default:
                    viewState = .error(message: ErrorMessageConstants.unknown)
                }
            }
        }
    }

    var verificationCodeIsValid: Bool {
        guard verificationCode.count == 6 else {
            viewState = .error(message: ErrorMessageConstants.invalidVerificationCodeLength)
            return false
        }

        guard Int(verificationCode) != nil else {
            viewState = .error(message: ErrorMessageConstants.verificationCodeIsNotANumber)
            return false
        }

        return true
    }

    func checkCodeLength() {
        if verificationCode.count > 6 {
            verificationCode = String(verificationCode.prefix(6))
        }
    }

    func postAccountConfirmedNotification() {
        NotificationCenter.default.post(
            name: .userConfirmedAccount,
            object: nil
        )
    }
}
