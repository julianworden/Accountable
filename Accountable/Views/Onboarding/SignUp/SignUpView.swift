//
//  SignUpView.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = SignUpViewModel()

    @ObservedObject var onboardingNavigationController: OnboardingNavigationController

    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: UiConstants.vStackSpacing) {
                        CenteredHeader(
                            title: "Sign Up",
                            subtitle: "You'll need to create an account before you can use Accountable"
                        )

                        TextFieldWithLine(
                            text: $viewModel.emailAddress,
                            iconName: "envelope",
                            placeholder: "Email Address",
                            keyboardType: .emailAddress,
                            isSecure: false
                        )

                        TextFieldWithLine(
                            text: $viewModel.confirmedEmailAddress,
                            iconName: "envelope",
                            placeholder: "Confirm Email Address",
                            keyboardType: .emailAddress,
                            isSecure: false
                        )

                        TextFieldWithLine(
                            text: $viewModel.password,
                            iconName: "key",
                            placeholder: "Password",
                            keyboardType: .default,
                            isSecure: true
                        )

                        TextFieldWithLine(
                            text: $viewModel.confirmedPassword,
                            iconName: "key",
                            placeholder: "Confirm Password",
                            keyboardType: .default,
                            isSecure: true
                        )

                        AsyncButton {
                            hideKeyboard()
                            await viewModel.signUpButtonTapped()
                        } label: {
                            Text("Sign Up")
                        }
                        .buttonStyle(Primary())
                        .disabled(viewModel.buttonsAreDisabled)
                    }
                    .padding(.horizontal)
                    .frame(minHeight: geo.frame(in: .global).height)
                }
                .scrollDismissesKeyboard(.interactively)
            }

            CustomBackButton()
        }
        .toolbar(.hidden)
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
        NavigationStack {
            SignUpView(onboardingNavigationController: OnboardingNavigationController())
                .navigationTitle("TEST")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
