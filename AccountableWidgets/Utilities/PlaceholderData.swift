//
//  PlaceholderData.swift
//  Accountable
//
//  Created by Julian Worden on 4/26/23.
//

import Foundation

struct PlaceholderData {
    static private(set) var projects = [
        Project(name: "Learn to Code", totalSecondsPracticed: 90_000, priority: .high)
    ]

    static private(set) var sessionHours = [
        6_500,
        9_000,
        5_800,
        8_000,
        4_000,
        11_000,
        3_000
    ]
}
