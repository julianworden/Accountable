//
//  SimpleEntry.swift
//  AccountableWidgetsExtension
//
//  Created by Julian Worden on 4/21/23.
//

import Foundation
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let userProjects: [Project]
    let userSessions: [Session]
    let isForPlaceholder: Bool

    var projectSessionsInPastSixDays: [Session] {
        return userSessions.filter { $0.unixDateAsDate.isInLastSixDays }
    }

    var totalHoursWorkedAcrossAllProjectsAsString: String {
        var secondsCount = 0

        userProjects.forEach {
            secondsCount += $0.totalSecondsPracticed
        }

        return secondsCount.secondsAsHoursString
    }

    var totalHoursWorkedAcrossAllProjectsAsInt: Int {
        var secondsCount = 0

        userProjects.forEach {
            secondsCount += $0.totalSecondsPracticed
        }

        return secondsCount.secondsAsHoursInt
    }

    init(date: Date, userProjects: [Project], userSessions: [Session], isForPlaceholder: Bool) {
        self.date = date
        self.userProjects = userProjects
        self.userSessions = userSessions
        self.isForPlaceholder = isForPlaceholder
    }

    func getTotalLengthOfSessionsInPastSixDays(for weekday: Weekday) -> Int {
        var totalDurationInSeconds = 0
        projectSessionsInPastSixDays.forEach {
            $0.weekday == weekday ? totalDurationInSeconds += $0.durationInSeconds : nil
        }

        return totalDurationInSeconds
    }
}
