//
//  Session+Helpers.swift
//  Accountable
//
//  Created by Julian Worden on 4/7/23.
//

import Amplify
import Foundation

extension Session: Equatable, Identifiable {
    public static func == (lhs: Session, rhs: Session) -> Bool {
        lhs.id == rhs.id
    }

    static let example = Session(
        project: Project.example,
        durationInSeconds: 30,
        unixDate: 1680904757,
        weekday: Weekday.friday
    )

    var unixDateAsDate: Date {
        Date(timeIntervalSince1970: unixDate)
    }

    var occurredInLastWeek: Bool {
        let dateOneWeekAgo = Date.now.addingTimeInterval(-DateConstants.secondsInSixDays)
        let dateOneWeekAgoAtMidnight = Calendar.current.startOfDay(for: dateOneWeekAgo)
        return unixDate > dateOneWeekAgoAtMidnight.timeIntervalSince1970 && unixDate <= Date.now.timeIntervalSince1970
    }
}
