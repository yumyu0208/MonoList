//
//  StoreManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/02.
//

import Foundation
import StoreKit

class StoreManager: NSObject, ObservableObject {
    
    var enablePlusContentAction: (() -> Void)!
    var presentErrorAlertAction: ((String) -> Void)!
    @Published var products: [SKProduct] = []
    @Published var transactionState: SKPaymentTransactionState?
    var request: SKProductsRequest!
    
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.products.append(fetchedProduct)
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func getProducts(productIds: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIds))
        request.delegate = self
        request.start()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
}

extension StoreManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                enablePlusContentAction()
                queue.finishTransaction(transaction)
                transactionState = .purchased
            case .restored:
                enablePlusContentAction()
                queue.finishTransaction(transaction)
                transactionState = .restored
            case .failed, .deferred:
                let error = transaction.error
                print("Payment Queue Error: \(String(describing: error))")
                if let errorDescription = error?.localizedDescription {
                    presentErrorAlertAction(errorDescription)
                }
                queue.finishTransaction(transaction)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        guard enablePlusContentAction != nil else { return }
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
            presentErrorAlertAction("You are not allowed to purchase this product with this account.")
        }
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
