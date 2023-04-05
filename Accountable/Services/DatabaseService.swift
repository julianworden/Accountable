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

    func getLoggedInUser() async throws -> User {
        do {
            let currentUserId = try await AuthService.shared.getLoggedInUserId()
            if let user = try await Amplify.DataStore.query(User.self, byId: currentUserId) {
                return user
            } else {
                throw DataStoreError.dataDoesNotExist
            }
        } catch {
            throw DataStoreError.unknown(message: "Failed to fetch user data. \(ErrorMessageConstants.unknown)")
        }
    }

    func getUser(withId id: String) async throws -> User {
        do {
            if let user = try await Amplify.DataStore.query(User.self, byId: id) {
                return user
            } else {
                throw DataStoreError.dataDoesNotExist
            }
        } catch {
            throw DataStoreError.unknown(message: "Failed to fetch user data. \(ErrorMessageConstants.unknown)")
        }
    }

    func getLoggedInUserProjects() async throws -> [Project] {
        do {
            let loggedInUser = try await DatabaseService.shared.getLoggedInUser()
            try await loggedInUser.projects?.fetch()

            if let loggedInUserProjects = loggedInUser.projects {
                return loggedInUserProjects.map { $0 }
            } else {
                return []
            }
        } catch {
            throw DataStoreError.unknown(message: "Failed to fetch project data. \(ErrorMessageConstants.unknown)")
        }
    }
}
