//
//  Project+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/5/23.
//

import Foundation

extension Project {
    static let example = Project(
        creator: User(username: "example@test.com"),
        name: "Run a marathon",
        priority: .high,
        description: "Run 3 miles every day."
    )
}
