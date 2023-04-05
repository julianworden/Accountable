//
//  Priority+CaseIterable.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import Foundation

// CaseIterable conformance declared here to prevent having to add the conformance every time the
// Priority enum is regenerated via Amplify.
extension Priority: CaseIterable {
    public static var allCases: [Priority] {
        [Priority.low, Priority.normal, Priority.high]
    }
}

// Identifiable conformance declared here to prevent having to add the conformance every time the
// Priority enum is regenerated via Amplify.
extension Priority: Identifiable {
    public var id: Self { self }
}
