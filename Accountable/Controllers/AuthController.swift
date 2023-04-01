//
//  AuthController.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import Amplify
import AWSCognitoAuthPlugin
import Foundation

struct AuthController {
    static func getAwsCognitoAuthError(from error: Error) -> AWSCognitoAuthError? {
        if let authError = error as? AuthError,
           let cognitoAuthError = authError.underlyingError as? AWSCognitoAuthError {
            return cognitoAuthError
        }

        return nil
    }
}
