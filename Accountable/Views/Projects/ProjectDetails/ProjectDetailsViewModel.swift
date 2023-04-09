//
//  ProjectDetailsViewModel.swift
//  Accountable
//´
//  Created by Julian Worden on 4/5/23.
//

import Foundation

@MainActor
final class ProjectDetailsViewModel: ObservableObject {
    @Published var projectSessions = [Session]()
    @Published var sessionViewIsShowing = false
    @Published var buttonsAreDisabled = false
    @Published var projectWasDeleted = false

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

    let project: Project

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

    func deleteProject() async {
        do {
            try await DatabaseService.shared.deleteProject(project)
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
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
