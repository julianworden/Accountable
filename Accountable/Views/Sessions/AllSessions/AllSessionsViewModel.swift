//
//  AllSessionsViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/8/23.
//

import Foundation

@MainActor
final class AllSessionsViewModel: ObservableObject {
    @Published var sessions: [Session]

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
            default:
                errorMessageText = ErrorMessageConstants.invalidViewState
                errorMessageIsShowing = true
            }
        }
    }

    init(sessions: [Session]) {
        self.sessions = sessions
    }

    func deleteSessionAt(_ indexSet: IndexSet) async {
        do {
            for index in indexSet {
                if sessions.indices.contains(index) {
                    let sessionToBeDeleted = sessions[index]
                    try await DatabaseService.shared.deleteSession(sessionToBeDeleted)
                    try FileManagerController.shared.deleteSession(sessionToBeDeleted)
                }
            }

            sessions.remove(atOffsets: indexSet)
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }
}
