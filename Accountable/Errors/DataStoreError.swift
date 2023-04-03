//
//  DatabaseServiceError.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Foundation

enum DataStoreError: LocalizedError {
    case unknown(message: String)

    var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return message
        }
    }
}
