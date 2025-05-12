//
//  GenericPasswordTypeExtensionsTests.swift
//  Keychain
//
//  Created by Yanko Dimitrov on 2/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import XCTest
@testable import SwiftKeychain

class GenericPasswordTypeExtensionsTests: XCTestCase {
    
    func testDefaultServiceName() {
        
        let item = MockGenericPasswordItem(accountName: "John")
        let expectedServiceName = "swift.keychain.service"
        
        XCTAssertEqual(item.serviceName, expectedServiceName, "Should contain the default service name")
    }
    
    func testDefaultAttributes() {
        
        let item = MockGenericPasswordItem(accountName: "John")
        let attributes = item.attributes
        
        let secClass = attributes[String(kSecClass)] as? String ?? ""
        let secAccessMode = attributes[String(kSecAttrAccessible)] as? String ?? ""
        let secService = attributes[String(kSecAttrService)] as? String ?? ""
        let secAccount = attributes[String(kSecAttrAccount)] as? String ?? ""
        
        XCTAssertEqual(secClass, String(kSecClassGenericPassword))
        XCTAssertEqual(secAccessMode, item.accessMode)
        XCTAssertEqual(secService, item.serviceName)
        XCTAssertEqual(secAccount, "John")
    }
}
