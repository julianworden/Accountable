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

    var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return message
        case .logic(let message):
            return message
        }
    }
}
