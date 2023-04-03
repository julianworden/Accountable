//
//  DatabaseService.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Amplify
import Foundation

final class DatabaseService {
    static let shared = DatabaseService()
    
    func authUserExistsInDataStore(_ authUser: AuthUser) async throws -> Bool {
        do {
            if try await Amplify.DataStore.query(User.self, byId: authUser.userId) != nil {
                return true
            } else {
                return false
            }
        } catch {
            throw DataStoreError.unknown(message: "Failed to determine if user already exists. \(ErrorMessageConstants.unknown)")
        }
    }

    func createUserInDataStore(_ user: User) async throws {
        do {
            try await Amplify.DataStore.save(user)
        } catch {
            throw DataStoreError.unknown(message: "Failed to save new user data. \(ErrorMessageConstants.unknown)")
        }
    }
}
