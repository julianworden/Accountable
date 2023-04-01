//
//  SignUpView.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()

    @ObservedObject var onboardingNavigationController: OnboardingNavigationController

    var body: some View {
        VStack(spacing: UiConstants.onboardingViewVStackSpacing) {
            OnboardingViewHeader(
                title: "Sign Up",
                subtitle: "You'll need to create an account before you can use Accountable"
            )

            TextFieldWithIcon(
                text: $viewModel.emailAddress,
                iconName: "envelope",
                placeholder: "Email Address",
                textFieldType: .email
            )

            TextFieldWithIcon(
                text: $viewModel.confirmedEmailAddress,
                iconName: "envelope",
                placeholder: "Confirm Email Address",
                textFieldType: .email
            )

            TextFieldWithIcon(
                text: $viewModel.password,
                iconName: "key",
                placeholder: "Password",
                textFieldType: .password
            )

            TextFieldWithIcon(
                text: $viewModel.confirmedPassword,
                iconName: "key",
                placeholder: "Confirm Password",
                textFieldType: .password
            )

            AsyncButton {
                await viewModel.signUpButtonTapped()
            } label: {
                Text("Sign Up")
            }
            .buttonStyle(Primary())
            .disabled(viewModel.buttonsAreDisabled)
        }
        .padding(.horizontal)
        .alert(
            "Error",
            isPresented: $viewModel.errorMessageIsShowing,
            actions: { Button("OK") { } },
            message: { Text(viewModel.errorMessageText) }
        )
        .onChange(of: onboardingNavigationController.userEmailAddress) { userEmailAddress in
            if userEmailAddress != nil {
                onboardingNavigationController.navigateToConfirmCodeView()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(onboardingNavigationController: OnboardingNavigationController())
    }
}
