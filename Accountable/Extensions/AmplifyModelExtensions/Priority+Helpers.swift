//
//  Priority+CaseIterable.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import Foundation

extension Priority: CaseIterable, Identifiable {
    public var id: Self { self }

    public static var allCases: [Priority] {
        [Priority.low, Priority.normal, Priority.high]
    }
}

