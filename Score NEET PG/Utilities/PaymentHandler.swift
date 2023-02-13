//
//  PaymentHandler.swift
//  Score MLE
//
//  Created by Manoj kumar on 05/08/22.
//

import Foundation
import StoreKit
import SwiftUI
import Combine




// MARK: - IN APP PURCHASE PAYMENT

class StoreManager: NSObject, ObservableObject  {
    
    let productID = "com.vongo.score.MLE.1.year.subscription"
    @Published var myProducts = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    
    
    var didSendRequest: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
    
    var didSendRestorePurchased: AnyPublisher<Void, Never> {
        restoredPurchase.eraseToAnyPublisher()
    }
    
    private let subject = PassthroughSubject<Void, Never>()
    private let restoredPurchase = PassthroughSubject<Void, Never>()
    
    var request: SKProductsRequest!
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
        
    }
    
    
    func updateSubscription() {
    
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        let parameter: [String : Any] = [
            "payment_expiry_date" : UserSession.userSessionInstance.createPackageExpirationDate()
        ]
        
        NetworkManager.shared.updateUser(mobileNumber: phoneNumber, parameters: parameter, apiType: "PATCH") { result in
            switch result {
            case .success(_):
                print("Date Updated")
                self.subject.send()
            case .failure(_):
                print("Date Not Updated")
            }
        }
        
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
}

extension StoreManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
                transactionState = .purchasing
            case .purchased:
                print("purchased")
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                //queue.finishTransaction(transaction)
                transactionState = .purchased
                updateSubscription()
                //subject.send()
                SKPaymentQueue.default().finishTransaction(transaction)

            case .restored:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                //queue.finishTransaction(transaction)
                
                print("restored")
                restoredPurchase.send()
                transactionState = .restored
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed, .deferred:
                print("failed")
                //queue.finishTransaction(transaction)
                transactionState = .failed
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print("failed fjkfhufkf")
                SKPaymentQueue.default().finishTransaction(transaction)
                //queue.finishTransaction(transaction)
            }
            
        }
    }
    
}
