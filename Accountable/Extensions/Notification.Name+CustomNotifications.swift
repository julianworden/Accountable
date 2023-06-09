//
//  Notification.Name+CustomNotifications.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import Foundation

extension Notification.Name {
    // MARK: - Auth

    static let userLoggedIn = Notification.Name("userLoggedIn")
    static let userSignedUp = Notification.Name("userSignedUp")
    static let userConfirmedAccount = Notification.Name("userConfirmedAccount")
    static let userLoggedOut = Notification.Name("userLoggedOut")

    // MARK: - Sessions

    static let newSessionCreated = Notification.Name("newSessionCreated")

    // MARK: - IAPS

    static let userUpgraded = Notification.Name("userUpgraded")
}
