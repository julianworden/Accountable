//
//  StoreKitTransactionController.swift
//  Accountable
//
//  Created by Julian Worden on 4/29/23.
//

import Foundation
import StoreKit

/// Responsible for handling new Transactions as soon as they occur. As noted in the Apple StoreKit Demo Xcode project, this only
/// works for it's necessary to "Iterate through any transactions that don't come from a direct call to `purchase()`." In testing, it appears
/// that the Transaction listener in this class only gets triggered by subscriptions and Transactions that are triggered in the background. Accountable,
/// does not have subscriptions so this class doesn't do anything as of now, but it will remain here in case such a feature will be added in the future.
final class StoreKitTransactionController: ObservableObject {
    var updates: Task<Void, Never>? = nil

    init() {
        updates = newTransactionListenerTask()
    }

    deinit {
        // Cancel the update handling task when you deinitialize the class.
        updates?.cancel()
    }

    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                await self.handle(updatedTransaction: verificationResult)
            }
        }
    }

    private func handle(updatedTransaction verificationResult: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = verificationResult else {
            // Ignore unverified transactions.
            return
        }

        if let revocationDate = transaction.revocationDate {
            print("Product revoked on \(revocationDate.formatted()) for reason: \(String(describing: transaction.revocationReason))")
        } else {
            // Deliver products to the user.
        }
    }
}
