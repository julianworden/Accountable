//
//  Int+secondsAsFullPeriodOfTime.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import Foundation

extension Int {
    var secondsAsFullPeriodOfTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: TimeInterval(self)) ?? ""
    }

    var secondsAsHours: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(self)) ?? ""
    }
}
