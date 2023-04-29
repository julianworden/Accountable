//
//  ProjectDetailsViewModel.swift
//  Accountable
//´
//  Created by Julian Worden on 4/5/23.
//

import Amplify
import Combine
import Foundation
import WidgetKit

@MainActor
final class ProjectDetailsViewModel: ObservableObject {
    @Published var projectSessions = [Session]()
    @Published var sessionViewIsShowing = false
    @Published var buttonsAreDisabled = false
    @Published var projectWasDeleted = false
    @Published var startNewSessionButtonIsShowing = true
    @Published var deleteProjectConfirmationAlertIsShowing = false

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .performingWork:
                buttonsAreDisabled = true
            case .workCompleted:
                projectWasDeleted = true
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
                buttonsAreDisabled = false
            default:
                errorMessageText = ErrorMessageConstants.invalidViewState
                errorMessageIsShowing = true
                buttonsAreDisabled = false
            }
        }
    }

    var projectSessionsInPastWeek: [Session] {
        projectSessions.filter { $0.unixDateAsDate.isInLastSixDays }
    }

    var totalHoursWorked: String {
        var totalTime = 0
        projectSessions.forEach {
            totalTime += $0.durationInSeconds
        }

        return totalTime.secondsAsHoursString
    }

    var averageHourWorkedPerSession: String {
        var totalTime = 0
        projectSessions.forEach {
            totalTime += $0.durationInSeconds
        }

        if !projectSessions.isEmpty {
            return Int(totalTime / projectSessions.count).secondsAsHoursString
        } else {
            return 0.secondsAsHoursString
        }
    }

    @Published var project: Project

    /// Holds the subscription for the project that's currently being shown by `ProjectDetailsView`. Necessary for updating the view
    /// when a `Session` is deleted, but does not update the view when a `Session` is created for reasons unknown.
    var projectSubscription: AnyCancellable?

    init(project: Project) {
        self.project = project
    }

    func getProjectSessions() async {
        do {
            projectSessions = try await DatabaseService.shared.getSessions(for: project)
        } catch {
            viewState = .error(message: error.localizedDescription)
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

    func deleteProject() async {
        do {
            try await DatabaseService.shared.deleteProject(project)
            try FileManagerController.shared.deleteProject(project)
            WidgetCenter.shared.reloadAllTimelines()
            projectWasDeleted = true
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func subscribeToProject() async {
        let project = Project.keys
        projectSubscription = Amplify.Publisher.create(
            Amplify.DataStore.observeQuery(for: Project.self, where: project.id == self.project.id)
        )
        .sink (
            receiveCompletion: { [weak self] in
                if case let .failure(error) = $0 {
                    print(error)
                    self?.viewState = .error(message: error.localizedDescription)
                }
            },
            receiveValue: { [weak self] querySnapshot in
                if let updatedProject = querySnapshot.items.first {
                    Task { @MainActor in
                        self?.project = updatedProject
                    }
                }
            }
        )
    }

    func unsubscribeFromProject() {
        projectSubscription?.cancel()
    }

    func addNewSessionCreatedObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNewSessionCreatedNotification(_:)),
            name: .newSessionCreated,
            object: nil
        )
    }

    @objc func handleNewSessionCreatedNotification(_ notification: Notification) {
        if let newSession = notification.userInfo?[NotificationConstants.newSession] as? Session {
            projectSessions.insert(newSession, at: 0)
        }
    }

    func removeNewSessionCreatedObserver() {
        NotificationCenter.default.removeObserver(self, name: .newSessionCreated, object: nil)
    }
}
