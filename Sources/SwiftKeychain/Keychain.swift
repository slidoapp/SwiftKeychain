//
//  Keychain.swift
//  Keychain
//
//  Created by Yanko Dimitrov on 2/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import Foundation

public typealias KeychainAttributes = [String: any Sendable]
public typealias KeychainData = [String: any Sendable]
public typealias KeychainItem = [String: any Sendable]

public struct Keychain: KeychainServiceType {

    public init() {
    }
    
    internal func errorForStatusCode(_ statusCode: OSStatus) -> NSError {
        
        return NSError(domain: "swift.keychain.error", code: Int(statusCode), userInfo: nil)
    }
    
    // Inserts or updates a keychain item with attributes
    
    public func insertItemWithAttributes(_ attributes: KeychainAttributes) throws {
        
        var statusCode = SecItemAdd(attributes as CFDictionary, nil)
        
        if statusCode == errSecDuplicateItem {
            
            SecItemDelete(attributes as CFDictionary)
            statusCode = SecItemAdd(attributes as CFDictionary, nil)
        }
        
        if statusCode != errSecSuccess {
            
            throw errorForStatusCode(statusCode)
        }
    }
    
    public func removeItemWithAttributes(_ attributes: KeychainAttributes) throws {
        
        let statusCode = SecItemDelete(attributes as CFDictionary)
        
        if statusCode != errSecSuccess {
            
            throw errorForStatusCode(statusCode)
        }
    }
    
    public func fetchItemWithAttributes(_ attributes: KeychainAttributes) throws -> KeychainItem? {
        
        var result: AnyObject?
        
        let statusCode = SecItemCopyMatching(attributes as CFDictionary, &result)
        
        if statusCode != errSecSuccess {
            
            throw errorForStatusCode(statusCode)
        }
        
        if let result = result as? KeychainItem {
            
            return result
        }
        
        return nil
    }
}
