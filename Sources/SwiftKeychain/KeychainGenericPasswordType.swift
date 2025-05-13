//
//  KeychainItemType.swift
//  SwiftKeychain
//
//  Created by Dominik Paľo on 07/05/2025.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import Foundation

public protocol KeychainGenericPasswordType: KeychainItemType {
    
    var serviceName: String { get }
    var accountName: String { get }
}

extension KeychainGenericPasswordType {
    
    public var serviceName: String {
        
        return "swift.keychain.service"
    }
    
    public var attributes: KeychainAttributes {
    
        var attributes = KeychainAttributes()
        
        attributes[String(kSecClass)] = kSecClassGenericPassword
        attributes[String(kSecAttrAccessible)] = accessMode
        attributes[String(kSecAttrService)] = serviceName
        attributes[String(kSecAttrAccount)] = accountName
        
        return attributes
    }
}
