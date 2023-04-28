//
//  LoginStatus.swift
//  Accountable
//
//  Created by Julian Worden on 3/29/23.
//

import Foundation

enum LoginStatus: Equatable {
    case notDetermined, loggedIn(currentUser: User), loggedOut, error(message: String)
}
