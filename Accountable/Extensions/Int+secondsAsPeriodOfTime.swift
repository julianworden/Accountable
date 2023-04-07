//
//  Int+secondsAsPeriodOfTime.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import Foundation

extension Int {
    var secondsAsPeriodOfTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: TimeInterval(self)) ?? ""
    }
}
