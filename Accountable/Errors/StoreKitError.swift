//
//  StoreKitError.swift
//  Accountable
//
//  Created by Julian Worden on 4/29/23.
//

import Foundation

enum StoreKitError: LocalizedError {
    case noProductsFetched

    var errorDescription: String? {
        switch self {
        case .noProductsFetched:
            return "Failed to fetch in-app purchases. Please try again."
        }
    }
}
