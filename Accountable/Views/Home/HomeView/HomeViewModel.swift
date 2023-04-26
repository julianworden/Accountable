//
//  HomeViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Amplify
import Security
import Foundation
import WidgetKit

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var userProjects = [Project]()
    @Published var userSessions = [Session]()
    @Published var addEditProjectSheetIsShowing = false

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @Published var viewState = ViewState.dataLoading {
        didSet {
            switch viewState {
            case .dataLoading, .dataLoaded, .dataNotFound:
                return
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
            default:
                print(viewState)
                errorMessageText = ErrorMessageConstants.invalidViewState
                errorMessageIsShowing = true
            }
        }
    }

    var totalHoursWorked: String {
        var totalHoursWorked = 0
        userProjects.forEach {
            totalHoursWorked += $0.totalSecondsPracticed
        }
        return totalHoursWorked.secondsAsHours
    }

    var projectSessionsInPastWeek: [Session] {
        userSessions.filter { $0.unixDateAsDate.isInLastSixDays }
    }

    init() {
        viewState = .dataLoading
    }

    func getLoggedInUserProjectsAndSessions() async {
        do {
            userProjects = try await DatabaseService.shared.getAllLoggedInUserProjects()
            if !userProjects.isEmpty {
                var userSessions = [Session]()

                for project in userProjects {
                    userSessions.append(contentsOf: try await DatabaseService.shared.getSessions(for: project))
                }

                self.userSessions = userSessions
            }
            viewState = .dataLoaded
        } catch {
            viewState = .error(message: ErrorMessageConstants.unknown)
        }
    }

    func getTotalLengthOfSessions(for weekday: Weekday) -> Int {
        var totalDurationInSeconds = 0
        projectSessionsInPastWeek.forEach {
            if $0.weekday == weekday {
                totalDurationInSeconds += $0.durationInSeconds
            }
        }

        return totalDurationInSeconds
    }

    func logOut() async {
        do {
            _ = await Amplify.Auth.signOut()
            try FileManagerController.shared.clearStoredUserData()
            clearKeychain()
            postLoggedOutNotification()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func postLoggedOutNotification() {
        NotificationCenter.default.post(name: .userLoggedOut, object: nil)
    }

    func clearKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword
        ]

        SecItemDelete(query as CFDictionary)
    }
}
