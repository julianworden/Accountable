//
//  ContentView.swift
//  Accountable
//
//  Created by Julian Worden on 3/26/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 25) {
            VStack(spacing: 7) {
                Text("Welcome!")
                    .font(.largeTitle.bold())

                Text("Thank you for staying Accountable with us.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
            }

            TextFieldWithIcon(
                text: $viewModel.emailAddress,
                iconName: "envelope",
                placeholder: "Email Address",
                isSecure: false
            )

            TextFieldWithIcon(
                text: $viewModel.password,
                iconName: "key",
                placeholder: "Password",
                isSecure: true
            )

            Button {

            } label: {
                Text("Log In")
                    .bold()
                    .foregroundColor(.white)
            }
            .tint(.white)
            .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            .background(.purple)
            .cornerRadius(10)

            HStack {
                CustomDivider()

                Text("Or log in with:")

                CustomDivider()
            }

            HStack(spacing: 15) {
                Button {

                } label: {
                    Image(systemName: "apple.logo")
                }
                .tint(.primary)
                .imageScale(.large)
                .socialSignInButtonStyle()

                Button {

                } label: {
                    Image("googleLogo")
                        .resizable()
                }
                .socialSignInButtonStyle()

                Button {

                } label: {
                    Image("facebookLogo")
                        .resizable()
                }
                .socialSignInButtonStyle()
            }

            HStack {
                Text("Don't have an account?")
                Button("Sign Up") {

                }
            }
        }
        .padding(.horizontal)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
