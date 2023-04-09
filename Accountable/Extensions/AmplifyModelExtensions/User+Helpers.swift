//
//  User+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/8/23.
//

import Foundation

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
