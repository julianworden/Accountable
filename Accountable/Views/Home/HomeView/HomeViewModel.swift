//
//  HomeViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Amplify
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var userProjects = [Project]()
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

    init() {
        viewState = .dataLoading
    }

    func getLoggedInUserProjects() async {
        do {
            userProjects = try await DatabaseService.shared.getLoggedInUserProjects()
            userProjects.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: ErrorMessageConstants.unknown)
        }
    }

    func logOut() async {
        _ = await Amplify.Auth.signOut()
        postLoggedOutNotification()
    }

    func printCurrentUserInfo() async {
        do {
            let currentAuthUser = try await Amplify.Auth.getCurrentUser()
            print("CURRENT USER: \(currentAuthUser)")
            let currentUserAttributes = try await Amplify.Auth.fetchUserAttributes()
            print("CURRENT USER ATTRIBUTES: \(currentUserAttributes)")
            let currentUser = try await DatabaseService.shared.getLoggedInUser()
            try await currentUser.projects?.fetch()
            if let currentUserProjects = currentUser.projects {
                for project in currentUserProjects {
                    print("CURRENT USER PROJECT: \(project.name)")
                }
            }
        } catch {
            print(error)
        }
    }

    func postLoggedOutNotification() {
        NotificationCenter.default.post(name: .userLoggedOut, object: nil)
    }
}
