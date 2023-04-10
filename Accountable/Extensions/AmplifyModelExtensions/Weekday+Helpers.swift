//
//  Weekday+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/9/23.
//

import Foundation

extension Weekday: CaseIterable, Identifiable {
    public var id: Self { self }

    public static var allCases: [Weekday] {
        [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }

    static func getWeekdayFor(_ date: Date) -> Weekday {
        let dateWeekday = date.formatted(.dateTime.weekday(.wide)).lowercased()
        return Weekday(rawValue: dateWeekday)!
    }

    var abbreviated: String {
        String(self.rawValue.capitalized.prefix(3))
    }
}
