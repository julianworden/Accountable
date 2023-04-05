//
//  DatabaseServiceError.swift
//  Accountable
//
//  Created by Julian Worden on 4/2/23.
//

import Foundation

enum DataStoreError: LocalizedError {
    case unknown(message: String)
    case dataDoesNotExist

    var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return message
        case .dataDoesNotExist:
            return "The queried data does not exist."
        }
    }
}
