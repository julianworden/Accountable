//
//  OnboardingNavigationController.swift
//  Accountable
//
//  Created by Julian Worden on 3/31/23.
//

import Foundation
import SwiftUI

final class OnboardingNavigationController: ObservableObject {
    @Published var navigationPath = [OnboardingNavigationDestination]()
    /// The email address of a new user that created an account. This is stored here so that it's readily
    /// accessible in ConfirmCodeView.
    @Published var userEmailAddress: String?

    init() {
        addUserSignedUpNotificationObserver()
        addUserConfirmedAccountNotificationObserver()
    }

    func navigateToSignUpView() {
        navigationPath.append(.signUpView)
    }

    func navigateToConfirmCodeView() {
        navigationPath.append(.confirmCodeView)
    }

    func popToRoot() {
        navigationPath = []
    }

    func addUserSignedUpNotificationObserver() {
        NotificationCenter.default.addObserver(forName: .userSignedUp, object: nil, queue: nil) { notification in
            if let emailAddress = notification.userInfo?[NotificationConstants.userEmailAddress] as? String {
                self.userEmailAddress = emailAddress
            }
        }
    }

    func addUserConfirmedAccountNotificationObserver() {
        NotificationCenter.default.addObserver(forName: .userConfirmedAccount, object: nil, queue: nil) { _ in
            self.popToRoot()
        }
    }
}
