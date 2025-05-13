//
//  MockKeychain.swift
//  SwiftKeychain
//
//  Created by Dominik Paľo on 07/05/2025.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import XCTest
import SwiftKeychain

class MockKeychain: KeychainServiceType {
    
    var isInsertCalled = false
    var isRemoveCalled = false
    var isFetchCalled = false
    
    func insertItemWithAttributes(_ attributes: KeychainAttributes) throws {
        
        isInsertCalled = true
    }
    
    func removeItemWithAttributes(_ attributes: KeychainAttributes) throws {
        
        isRemoveCalled = true
    }
    
    func fetchItemWithAttributes(_ attributes: KeychainAttributes) throws -> KeychainItem? {
        
        isFetchCalled = true
        
        let data = try NSKeyedArchiver.archivedData(withRootObject: [
            "token": "123456",
            "date": NSDate.init(timeIntervalSince1970: 123456)
        ], requiringSecureCoding: true)
        
        return [String(kSecValueData): data]
    }
}
