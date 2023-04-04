//
//  ConfirmCodeView.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import SwiftUI

struct ConfirmCodeView: View {
    @StateObject private var viewModel: ConfirmCodeViewModel
    @ObservedObject var onboardingNavigationController: OnboardingNavigationController

    init(onboardingNavigationController: OnboardingNavigationController) {
        _viewModel = StateObject(wrappedValue: ConfirmCodeViewModel(emailAddress: onboardingNavigationController.userEmailAddress))
        self.onboardingNavigationController = onboardingNavigationController
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: UiConstants.vStackSpacing) {
                    OnboardingViewHeader(
                        title: "Enter Code",
                        subtitle: "A verification code was sent to your email address, please enter it below."
                    )

                    TextFieldWithLine(
                        text: $viewModel.verificationCode,
                        iconName: "key",
                        placeholder: "Verification Code",
                        keyboardType: .numberPad,
                        isSecure: false
                    )
                    .onChange(of: viewModel.verificationCode) { _ in
                        viewModel.checkCodeLength()
                    }

                    AsyncButton {
                        hideKeyboard()
                        await viewModel.verifyButtonTapped()
                    } label: {
                        Text("Verify")
                    }
                    .buttonStyle(Primary())
                    .disabled(viewModel.buttonsAreDisabled)
                    .alert(
                        "Success!",
                        isPresented: $viewModel.successfulVerificationAlertIsShowing,
                        actions: {
                            Button("OK") {
                                viewModel.postAccountConfirmedNotification()
                            }
                        },
                        message: { Text("Your account was successfully verified! Tap the OK button to sign in and start using Accountable.") }
                    )
                }
                .padding(.horizontal)
                .frame(minHeight: geo.size.height)
                .toolbar(.hidden)
                .alert(
                    "Error",
                    isPresented: $viewModel.errorMessageIsShowing,
                    actions: { Button("OK") { } },
                    message: { Text(viewModel.errorMessageText) }
                )
        }
        }
    }
}

struct ConfirmCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmCodeView(onboardingNavigationController: OnboardingNavigationController())
    }
}
