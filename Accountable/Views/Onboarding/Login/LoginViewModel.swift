//
//  LogInViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import AWSCognitoAuthPlugin
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""

    
}
