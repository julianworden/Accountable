//
//  Project+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import Foundation

extension Project: Equatable, Identifiable {
    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }

    func getSessions() async throws -> [Session] {
        try await self.sessions?.fetch()
        if let projectSessions = self.sessions {
            return projectSessions.map { $0 }
        } else {
            return []
        }
    }

    static let example = Project(
        creator: User(username: "example@test.com", isPremium: true),
        name: "Run a marathon",
        totalSecondsPracticed: 0,
        priority: .high,
        description: "Run 3 miles every day."
    )
}
