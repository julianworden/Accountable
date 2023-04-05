//
//  AuthService.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Amplify
import Foundation

class AuthService {
    static let shared = AuthService()

    func getLoggedInUserEmailAddress() async throws -> String {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()

            if session.isSignedIn {
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                if let emailAddressAttribute = attributes.first(where: { $0.key == .email }) {
                    return emailAddressAttribute.value
                } else {
                    throw AuthServiceError.logic(message: "No email address attribute found in user's attributes.")
                }
            } else {
                throw AuthServiceError.logic(message: "No one is signed in, so the current user's email address cannot be fetched.")
            }
        } catch {
            throw AuthServiceError.unknown(message: "Failed to fetch logged in user's email address. \(ErrorMessageConstants.unknown)")
        }
    }

    func getLoggedInUserId() async throws -> String {
        do {
            let currentUser = try await Amplify.Auth.getCurrentUser()
            return currentUser.userId
        } catch {
            throw AuthServiceError.unknown(message: "Failed to fetch logged in user's ID. \(ErrorMessageConstants.unknown)")
        }
    }
}
