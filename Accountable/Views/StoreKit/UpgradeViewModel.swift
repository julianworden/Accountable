//
//  UpgradeViewModel.swift
//  Accountable
//
//  Created by Julian Worden on 4/28/23.
//

import Foundation
import StoreKit

@MainActor
final class UpgradeViewModel: ObservableObject {
    @Published var accountablePremium: Product?
    let currentUser: User

    @Published var errorMessageIsShowing = false
    var errorMessageText = ""
    @Published var buttonsAreDisabled = false
    @Published var dismissView = false

    @Published var viewState = ViewState.dataLoading {
        didSet {
            switch viewState {
            case .dataLoading, .dataLoaded, .dataNotFound:
                return
            case .performingWork:
                buttonsAreDisabled = true
            case .workCompleted:
                buttonsAreDisabled = false
                dismissView = true
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
                buttonsAreDisabled = false
            default:
                errorMessageText = ErrorMessageConstants.invalidViewState
                errorMessageIsShowing = true
                buttonsAreDisabled = false
            }
        }
    }

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func fetchAvailableProducts() async {
        do {
            let allProducts = try await Product.products(for: [StoreKitConstants.premiumProductId])

            guard !allProducts.isEmpty &&
                  allProducts.count == 1,
                  let accountablePremium = allProducts.first else {
                viewState = .dataNotFound
                return
            }

            self.accountablePremium = accountablePremium
            viewState = .dataLoaded
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func purchase(_ product: Product) async {
        do {
            viewState = .performingWork

            let purchaseResult = try await product.purchase(
                options: [.appAccountToken(UUID(uuidString: currentUser.id)!)]
            )

            switch purchaseResult {
            case .success(let verificationResult):
                switch verificationResult {
                case .verified(let transaction):
                    let upgradedUser = try await DatabaseService.shared.makeCurrentUserPremium()
                    postUserUpgradedNotification(forUser: upgradedUser)
                    await transaction.finish()
                    viewState = .workCompleted
                case .unverified(_, let verificationError):
                    viewState = .error(message: "There was an error processing this transaction, your purchase is not verified. System Error: \(verificationError.localizedDescription)")
                }

            default:
                break
            }
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func postUserUpgradedNotification(forUser user: User) {
        NotificationCenter.default.post(
            name: .userUpgraded,
            object: nil,
            userInfo: [NotificationConstants.upgradedUser: user]
        )
    }
}
