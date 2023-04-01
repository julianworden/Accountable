//
//  ContentView.swift
//  Accountable
//
//  Created by Julian Worden on 3/26/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var onboardingNavigationController = OnboardingNavigationController()

    var body: some View {
        NavigationStack(path: $onboardingNavigationController.navigationPath) {
            VStack(spacing: UiConstants.onboardingViewVStackSpacing) {
                OnboardingViewHeader(
                    title: "Welcome!",
                    subtitle: "Thank you for staying Accountable with us."
                )

                TextFieldWithIcon(
                    text: $viewModel.emailAddress,
                    iconName: "envelope",
                    placeholder: "Email Address",
                    textFieldType: .email
                )

                TextFieldWithIcon(
                    text: $viewModel.password,
                    iconName: "key",
                    placeholder: "Password",
                    textFieldType: .password
                )

                AsyncButton {
                    await viewModel.signInWithEmailAndPassword()
                } label: {
                    Text("Log In")
                }
                .buttonStyle(Primary())
                .disabled(viewModel.buttonsAreDisabled)
                .alert(
                    "Error",
                    isPresented: $viewModel.unverifiedAccountAlertIsShowing,
                    actions: {
                        Button("Cancel", role: .cancel) { }
                        Button("Send Code") {
                            Task {
                                await viewModel.sendConfirmationCode()
                            }
                        }
                    },
                    message: {
                        Text("It looks like you signed up for Accountable, but you haven't verified your account. Tap the button below to send a verification email to \(viewModel.emailAddress).")
                    }
                )
                .onChange(of: onboardingNavigationController.userEmailAddress) { userEmailAddress in
                    if userEmailAddress != nil {
                        onboardingNavigationController.navigateToConfirmCodeView()
                    }
                }

                HStack {
                    CustomDivider()

                    Text("Or log in with:")

                    CustomDivider()
                }

                LoginSocialMediaButtons(viewModel: viewModel)

                HStack {
                    Text("Don't have an account?")
                    Button("Sign Up") {
                        onboardingNavigationController.navigateToSignUpView()
                    }
                }
            }
            .padding(.horizontal)
            .alert(
                "Error",
                isPresented: $viewModel.errorMessageIsShowing,
                actions: { Button("OK") { } },
                message: { Text(viewModel.errorMessageText) }
            )
            .navigationDestination(for: OnboardingNavigationDestination.self) { onboardingNavigationDestination in
                switch onboardingNavigationDestination {
                case .signUpView:
                    SignUpView(onboardingNavigationController: onboardingNavigationController)
                case .confirmCodeView:
                    ConfirmCodeView(onboardingNavigationController: onboardingNavigationController)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
