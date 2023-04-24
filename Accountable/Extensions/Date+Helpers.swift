//
//  Date+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/23/23.
//

import Foundation

extension Date {
    var isInLastSixDays: Bool {
        let dateSixDaysAgo = Date.now.addingTimeInterval(-DateConstants.secondsInSixDays)
        let dateSixDaysAgoAtMidgnight = Calendar.current.startOfDay(for: dateSixDaysAgo)
        return self > dateSixDaysAgoAtMidgnight && self <= Date.now
    }

    var weekday: String {
        return self.formatted(.dateTime.weekday(.wide)).lowercased()
    }
}
