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

    // MARK: - Users

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

    func createOrUpdateUser(_ user: User) async throws {
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

    // MARK: - Projects

    func createProject(_ project: Project) async throws {
        do {
            try await Amplify.DataStore.save(project)
        } catch {
            throw DataStoreError.unknown(message: "Failed to save project. \(ErrorMessageConstants.unknown)")
        }
    }

    func deleteProject(_ project: Project) async throws {
        do {
            try await Amplify.DataStore.delete(project)
        } catch {
            throw DataStoreError.unknown(message: "Failed to delete project. \(ErrorMessageConstants.unknown)")
        }
    }

    // MARK: - Sessions

    func createSession(_ session: Session) async throws {
        do {
            try await Amplify.DataStore.save(session)
        } catch {
            throw DataStoreError.unknown(message: "Failed to save session. \(ErrorMessageConstants.unknown)")
        }
    }

    func getSessions(for project: Project) async throws -> [Session] {
        do {
            try await project.sessions?.fetch()
            if let projectSessions = project.sessions {
                return projectSessions.map { $0 }.sorted { $0.unixDate > $1.unixDate }
            }

            return []
        } catch {
            throw DataStoreError.unknown(message: "Failed to fetch project sessions. \(ErrorMessageConstants.unknown)")
        }
    }
}
