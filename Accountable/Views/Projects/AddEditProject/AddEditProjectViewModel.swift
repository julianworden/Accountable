//
//  AddEditProjectViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/3/23.
//

import Amplify
import Foundation

@MainActor
final class AddEditProjectViewModel: ObservableObject {
    @Published var projectName = ""
    @Published var projectDescription = ""
    @Published var selectedPriorityIndex = 1
    @Published var buttonsAreDisabled = false
    @Published var projectOperationCompleted = false

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .performingWork:
                buttonsAreDisabled = true
            case .workCompleted:
                buttonsAreDisabled = false
                projectOperationCompleted = true
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

    func createProject() async {
        guard !projectName.isReallyEmpty else {
            viewState = .error(message: ErrorMessageConstants.noProjectNameEntered)
            return
        }

        do {
            viewState = .performingWork
            let loggedInUser = try await DatabaseService.shared.getLoggedInUser()

            let project = Project(
                creator: loggedInUser,
                name: projectName,
                totalSecondsPracticed: 0,
                priority: Priority.allCases[selectedPriorityIndex],
                description: projectDescription
            )

            try await DatabaseService.shared.createOrUpdateProject(project)
            try FileManagerController.shared.saveProject(project)

            viewState = .workCompleted
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }
}
