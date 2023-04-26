//
//  KeychainError.swift
//  Accountable
//
//  Created by Julian Worden on 4/19/23.
//

import Foundation

enum KeychainError: LocalizedError {
    case itemDoesNotExist
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)

    var errorDescription: String? {
        switch self {
        case .itemDoesNotExist:
            return "Log in via the Accountable app to see your data."
        case .unexpectedPasswordData:
            return ErrorMessageConstants.unknownForWidget
        case .unhandledError(let status):
            return "Something went wrong. Error code: \(status)"
        }
    }
}
