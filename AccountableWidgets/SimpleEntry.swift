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

    var projectSessionsInPastSixDays: [Session] {
        return userSessions.filter { $0.createdInLastSixDays }
    }

    init(date: Date, userProjects: [Project], userSessions: [Session], errorMessage: String? = nil) {
        self.date = date
        self.userProjects = userProjects
        self.userSessions = userSessions
        self.errorMessage = errorMessage
    }

    func getTotalLengthOfSessionsInPastSixDays(for weekday: Weekday) -> Int {
        var totalDurationInSeconds = 0
        projectSessionsInPastSixDays.forEach {
            $0.weekday == weekday ? totalDurationInSeconds += $0.durationInSeconds : nil
        }

        return totalDurationInSeconds
    }
}
