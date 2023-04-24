//
//  Int+secondsAsFullPeriodOfTime.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import Foundation

extension Int {
    /// Converts a number of seconds to a readable string that displays hour, minute, and second values for that number of seconds.
    /// Any zero values are dropped. For example, if a time period is exactly 1 hour, the string will only show the hour value and ignore the
    /// 0 minute and second values.
    var secondsAsFullPeriodOfTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: TimeInterval(self)) ?? ""
    }

    /// Converts a number of seconds to a readable string that displays the hour value for that number of seconds. Zeroes are not dropped,
    /// so if the number of seconds is less than an hour, this extension will return '0h' instead of an empty string.
    var secondsAsHours: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(self)) ?? ""
    }
}
