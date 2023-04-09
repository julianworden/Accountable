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

    static let example = Project(
        creator: User(username: "example@test.com"),
        name: "Run a marathon",
        priority: .high,
        description: "Run 3 miles every day."
    )
}
