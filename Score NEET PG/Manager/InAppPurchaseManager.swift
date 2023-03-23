//
//  InAppPurchaseManager.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 10/02/23.
//

import SwiftUI
import StoreKit
import Combine

// https://sandbox.itunes.apple.com/verifyReceipt
// https://buy.itunes.apple.com/verifyReceipt

enum EnvironmentInAppPurchase {
    case sandbox
    case live
    
    var serverURL: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        case .live:
            return URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
        }
    }
}

class InAppPurchaseManager: NSObject, ObservableObject {
    
    static let shared = InAppPurchaseManager()
    
    private let productIdentifiers: Set<String> = [
        "com.vongo.score.MLE.1.year.subscription",
        "com.vongo.score.nurse.yearly.subscription",
        "com.vongo.score.usmle1.yearly.subscription"
    ]
    
    private var productsRequest: SKProductsRequest?
    var products: [SKProduct] = []
    
    var didSendRequest: AnyPublisher<Void, Never> {
        subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<Void, Never>()
    
    @Published var isLoading = false
    @Published var isPurchased = false
    @Published var plan: String?
    
    private override init() {
        super.init()
        loadProducts()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    private func loadProducts() {
        isLoading = true
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func purchase(product: SKProduct) {
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func validateReceipt() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let environment: EnvironmentInAppPurchase
        
        guard let receiptUrl = Bundle.main.appStoreReceiptURL, let receiptData = try? Data(contentsOf: receiptUrl) else { return }
        
        let requestContents = [
            "receipt-data": receiptData.base64EncodedString(),
            "password": "53c70e77c8f94df3821e32b469aa0c26"
        ]
        
        guard let requestData = try? JSONSerialization.data(withJSONObject: requestContents, options: []) else {
            return
        }
        
        if receiptData.starts(with: "Sandbox".data(using: .utf8)!) {
            environment = .sandbox
        } else {
            environment = .live
        }
        
        let receiptValidationURL = environment.serverURL
        
        var request = URLRequest(url: receiptValidationURL)
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
            }
            guard let data = data, error == nil else {
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let status = json["status"] as? Int,
               status == 0,
               let receipt = json["receipt"] as? [String: Any],
               let inAppPurchases = receipt["in_app"] as? [[String: Any]] {
                for purchase in inAppPurchases {
                    if let productId = purchase["product_id"] as? String,
                       let expiresDateMs = purchase["expires_date_ms"] as? String,
                       let expiresDate = Double(expiresDateMs),
                       expiresDate > Date().timeIntervalSince1970 * 1000 {
                        self.isPurchased = true
                        self.plan = productId
                        self.updateSubscription()
                        //self.subject.send()
                        break
                    }
                }
            }
        }.resume()
        
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
    
}

//MARK: - SKProductsRequestDelegate
extension InAppPurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
            self.isLoading = false
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}


//MARK: - SKPaymentTransactionObserver
extension InAppPurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                validateReceipt()
                queue.finishTransaction(transaction)
                break
            case .failed:
                queue.finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                break
            case .restored:
                validateReceipt()
                queue.finishTransaction(transaction)
                break
            default:
                break
            }
        }
    }
}
