//
//  Session+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import Foundation

extension Session {
    static let example = Session(
        project: Project.example,
        durationInSeconds: 30,
        unixDate: 1680904757
    )

    var unixDateAsDate: Date {
        Date(timeIntervalSince1970: unixDate)
    }
}
