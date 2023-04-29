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
    @Published var currentUser: User
    @Published var userProjects = [Project]()
    @Published var userSessions = [Session]()
    @Published var addEditProjectSheetIsShowing = false
    @Published var upgradeSheetIsShowing = false
    @Published var upgradeNeededAlertIsShowing = false

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

    var userCanCreateNewProject: Bool {
        if currentUser.isPremium {
            return true
        } else if !currentUser.isPremium && userProjects.count >= 3 {
            return false
        } else {
            return false
        }
    }

    var totalHoursWorked: String {
        var totalHoursWorked = 0
        userProjects.forEach {
            totalHoursWorked += $0.totalSecondsPracticed
        }
        return totalHoursWorked.secondsAsHoursString
    }

    var projectSessionsInPastWeek: [Session] {
        userSessions.filter { $0.unixDateAsDate.isInLastSixDays }
    }


    var averageHourWorkedPerSession: String {
        var totalTime = 0
        userSessions.forEach {
            totalTime += $0.durationInSeconds
        }
        
        // Without this check, having no sessions will result in "Division by zero" crash
        if !userSessions.isEmpty {
            return Int(totalTime / userSessions.count).secondsAsHoursString
        } else {
            return 0.secondsAsHoursString
        }
    }

    init(currentUser: User) {
        self.currentUser = currentUser
        if !currentUser.isPremium {
            addUserUpgradedNotificationObserver()
        }
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
            } else if userProjects.isEmpty {
                userSessions = []
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

    func addUserUpgradedNotificationObserver() {
        NotificationCenter.default.addObserver(forName: .userUpgraded, object: nil, queue: nil) { notification in
            if let currentUser = notification.userInfo?[NotificationConstants.upgradedUser] as? User {
                Task { @MainActor in
                    self.currentUser = currentUser
                    self.removeUserUpgradedNotificationObserver()
                }
            }
        }
    }

    func removeUserUpgradedNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: .userUpgraded, object: nil)
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
