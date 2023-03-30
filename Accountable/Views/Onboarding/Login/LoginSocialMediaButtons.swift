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
    }
}

struct LogInWithView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSocialMediaButtons(viewModel: LoginViewModel())
    }
}
