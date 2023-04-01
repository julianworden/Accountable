//
//  LoginSocialMediaButtons.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import SwiftUI

struct LoginSocialMediaButtons: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        HStack(spacing: 15) {
            Button {
                Task {
                    await viewModel.signInWithApple()
                }
            } label: {
                Image(systemName: "apple.logo")
            }
            .tint(.primary)
            .imageScale(.large)
            .buttonStyle(SocialSignIn())

            Button {
                Task {
                    await viewModel.signInWithGoogle()
                }
            } label: {
                Image("googleLogo")
                    .resizable()
            }
            .buttonStyle(SocialSignIn())
        }
    }
}

struct LogInWithView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSocialMediaButtons(viewModel: LoginViewModel())
    }
}
