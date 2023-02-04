//
//  KeyChainPropertyWrapper.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import SwiftUI

// MARK: - Custom Wrapper For Keychain
//For easy to use
@propertyWrapper
struct KeyChain: DynamicProperty {
    
    @State var data: Data?
    
    var wrappedValue: Data? {
        get { data }
        set {
            
            guard let newData = newValue else {
                //If we set data to nil
                // Simply delete the keychain Data
                data = nil
                KeyChainHelper.standard.delete(key: key, account: account)
                return
            }
            
            //Updating or Setting Keychain Data
            KeyChainHelper.standard.save(data: newData, key: key, account: account)
        }
    }
    
    var key: String
    var account: String
    
    init(key: String, account: String) {
        self.key = key
        self.account = account
        
        //Setting Initial State Keychain Data
        _data = State(wrappedValue: KeyChainHelper.standard.read(key: key, account: account))
    }
}
