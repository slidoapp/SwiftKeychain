//
//  MockKeychainItem.swift
//  SwiftKeychain
//
//  Created by Dominik Paľo on 07/05/2025.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import XCTest
import SwiftKeychain

/// A mock implementation of `KeychainItemType` containing `NSDate` class for testing purposes.
/// The `storedClasses` property is set to `[NSDate.self]` to allow storing the `NSDate` in the keychain.
struct MockKeychainItem: KeychainItemType {
    
    var attributes: KeychainAttributes {
        
        return [String(kSecClass): kSecClassGenericPassword]
    }
    
    var data = KeychainData()
    
    var dataToStore: KeychainData {
        
        return [
            "token": "123456",
            "date": NSDate(timeIntervalSince1970: 123456)
        ]
    }
    
    var storedClasses: [AnyClass] {

        return [NSDate.self]
    }
}

/// A simple mock implementation of `KeychainItemType` for testing purposes.
/// Simple means, that it stores only value data and does not contain any classes,
/// so the `storedClasses` property doesn't need to be set.
struct MockKeychainItemSimple: KeychainItemType {
    
    var attributes: KeychainAttributes {
        
        return [String(kSecClass): kSecClassGenericPassword]
    }
    
    var data = KeychainData()
    
    var dataToStore: KeychainData {
        
        return [
            "token": "123456"
        ]
    }
}

/// A mock implementation of `KeychainGenericPasswordType` for testing purposes.
/// The `storedClasses` property is set to `[NSDate.self]` to allow storing the `NSDate` in the keychain.
struct MockGenericPasswordItem: KeychainGenericPasswordType {
    
    let accountName: String
    var data = KeychainData()
    
    var dataToStore: KeychainData {
        
        return [
            "token": "123456",
            "date": NSDate(timeIntervalSince1970: 123456)
        ]
    }
    
    var storedClasses: [AnyClass] {

        return [NSDate.self]
    }
    
    init(accountName: String) {
        
        self.accountName = accountName
    }
}

/// Thiis item is used to test the case when the `KeychainItemType` protocol is not implemented correctly.
/// It does not implement the `storedClasses` property, which is required when the stored data contains any
/// classes, like `NSDate` in this case.
struct MockGenericPasswordItemMisconfigured: KeychainGenericPasswordType {
    
    let accountName: String
    var data = KeychainData()
    
    var dataToStore: KeychainData {
        
        return [
            "token": "123456",
            "date": NSDate(timeIntervalSince1970: 123456)
        ]
    }
    
    init(accountName: String) {
        
        self.accountName = accountName
    }
}
