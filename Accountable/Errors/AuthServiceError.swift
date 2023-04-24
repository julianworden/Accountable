//
//  AuthServiceError.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Foundation

enum AuthServiceError: LocalizedError {
    case unknown(message: String)
    case logic(message: String)
    case userSignedOut

    var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return message
        case .logic(let message):
            return message
        case .userSignedOut:
            return "The current user is signed out."
        }
    }
}
