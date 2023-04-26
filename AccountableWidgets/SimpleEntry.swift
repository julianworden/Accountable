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
    let errorMessage: String?
    let isForPlaceholder: Bool

    var projectSessionsInPastSixDays: [Session] {
        return userSessions.filter { $0.unixDateAsDate.isInLastSixDays }
    }

    var totalHoursWorkedAcrossAllProjects: String {
        var hoursCount = 0

        userProjects.forEach {
            hoursCount += $0.totalSecondsPracticed
        }

        return hoursCount.secondsAsHours
    }

    init(date: Date, userProjects: [Project], userSessions: [Session], errorMessage: String? = nil, isForPlaceholder: Bool) {
        self.date = date
        self.userProjects = userProjects
        self.userSessions = userSessions
        self.errorMessage = errorMessage
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
