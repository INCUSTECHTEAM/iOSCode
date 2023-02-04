//
//  KeyChainHelper.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI

// MARK: - Keychain Helper Class
class KeyChainHelper {
    
    // To Access Class Data
    static let standard = KeyChainHelper()
    
    // MARK: - Saving KeyChain Value
    func save(data: Data, key: String, account: String) {
        
        // Creating Query
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        //Adding Data to Keychain
        let status = SecItemAdd(query, nil)
        
        //Checking for Status
        switch status {
            //Success
        case errSecSuccess:
            print("Success")
            //Updaing Data
        case errSecDuplicateItem:
            let query = [
                kSecValueData: data,
                kSecAttrAccount: account,
                kSecAttrService: key,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            //Update Field
            let updateAttr = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(query, updateAttr)
            
            //Other wise Error
        default:
            print("Error \(status)")
        }
        
    }
    
    // MARK: - Reading KeyChain Data
    func read(key: String, account: String) -> Data? {
        
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        //To Copy the Data
        var resultData: AnyObject?
        SecItemCopyMatching(query, &resultData)
        
        return (resultData as? Data)
    }
    
    
    // MARK: - Deleting KeyChain Data
    func delete(key: String, account: String) {
        
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
