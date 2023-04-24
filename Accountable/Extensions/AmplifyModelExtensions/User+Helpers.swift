//
//  User+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/8/23.
//

import Foundation

extension User: Equatable {
    static var example = User(username: "example@gmail.com")

    func getProjects() async throws -> [Project] {
        do {
            try await self.projects?.fetch()
            if let userProjects = self.projects {
                return userProjects.map { $0 }
            } else {
                return []
            }
        } catch {
            throw DataStoreError.unknown(message: "Failed to fetch user's projects. \(ErrorMessageConstants.unknown)")
        }
    }

    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
