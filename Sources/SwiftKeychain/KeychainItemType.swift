//
//  KeychainItemType.swift
//  SwiftKeychain
//
//  Created by Dominik Paľo on 07/05/2025.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import Foundation

public protocol KeychainItemType {
    
    var accessMode: String { get }
    var accessGroup: String? { get }
    var attributes: KeychainAttributes { get }
    var data: KeychainData { get set }
    var dataToStore: KeychainData { get }
}

extension KeychainItemType {
    
    public var accessMode: String {
        
        return String(kSecAttrAccessibleWhenUnlocked)
    }
    
    public var accessGroup: String? {
        
        return nil
    }
}

extension KeychainItemType {
    
    internal var attributesToSave: KeychainAttributes {
        
        var itemAttributes = attributes
        let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: dataToStore, requiringSecureCoding: false)
        
        itemAttributes[String(kSecValueData)] = archivedData
        
        if let group = accessGroup {
            
            itemAttributes[String(kSecAttrAccessGroup)] = group
        }
        
        return itemAttributes
    }
    
    internal func dataFromAttributes(_ attributes: KeychainAttributes) -> KeychainData? {
        
        guard let valueData = attributes[String(kSecValueData)] as? Data else { return nil }
        
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: valueData) as? KeychainData
    }
    
    internal var attributesForFetch: KeychainAttributes {
        
        var itemAttributes = attributes
        
        itemAttributes[String(kSecReturnData)] = kCFBooleanTrue
        itemAttributes[String(kSecReturnAttributes)] = kCFBooleanTrue
        
        if let group = accessGroup {
            
            itemAttributes[String(kSecAttrAccessGroup)] = group
        }
        
        return itemAttributes
    }
}

// MARK: - KeychainItemType + Keychain

extension KeychainItemType {
    
    public func saveInKeychain(_ keychain: KeychainServiceType = Keychain()) throws {
        
        try keychain.insertItemWithAttributes(attributesToSave)
    }
    
    public func removeFromKeychain(_ keychain: KeychainServiceType = Keychain()) throws {
        
        try keychain.removeItemWithAttributes(attributes)
    }
    
    public mutating func fetchFromKeychain(_ keychain: KeychainServiceType = Keychain()) throws -> Self {
        
        if  let result = try keychain.fetchItemWithAttributes(attributesForFetch),
            let itemData = dataFromAttributes(result) {
            
            data = itemData
        }
        
        return self
    }
}
