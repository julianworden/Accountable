//
//  FileManagerError.swift
//  Accountable
//
//  Created by Julian Worden on 4/24/23.
//

import Foundation

enum FileManagerError: LocalizedError {
    case writeFailed(message: String)
    case readFailed(message: String)

    var errorDescription: String? {
        switch self {
        case .writeFailed(let message), .readFailed(let message):
            return message
        }
    }
}
