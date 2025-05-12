// SPDX-License-Identifier: MIT
//
//  KeychainTests.swift
//  KeychainTests
//
//  Created by Yanko Dimitrov on 2/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2024 Cisco Systems, Inc.
//

import XCTest
@testable import SwiftKeychain

class KeychainTests: XCTestCase {
    
    func testErrorForStatusCode() {
        
        let keychain = Keychain()
        
        let expectedErrorCode = Int(errSecItemNotFound)
        let error = keychain.errorForStatusCode(errSecItemNotFound)
        
        XCTAssertEqual(error.code, expectedErrorCode, "Should return error with status code")
    }
    
    func testInsertItemWithAttributes() {
        
        let item = MockGenericPasswordItem(accountName: "John_testInsertItemWithAttributes")
        let keychain = Keychain()
        
        XCTAssertNoThrow(try keychain.insertItemWithAttributes(item.attributes), "Should insert item with attributes in the Keychain")
    }
    
    func testInsertItemWithAttributesThrowsError() {
        
        let attributes = ["a": "b"]
        let keychain = Keychain()

        XCTAssertThrowsError(try keychain.insertItemWithAttributes(attributes), "Should throw error when the operation fails") { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "swift.keychain.error")
            XCTAssertEqual(nsError.code, Int(errSecParam))
        }
    }
    
    func testRemoveItemWithAttributes() throws {
        
        let item = MockGenericPasswordItem(accountName: "John_testRemoveItemWithAttributes")
        let keychain = Keychain()
        
        try keychain.insertItemWithAttributes(item.attributes)
        
        XCTAssertNoThrow(try keychain.removeItemWithAttributes(item.attributes), "Should remove item with attributes from the Keychain")
    }
    
    func testRemoveItemWithAttributesThrowsError() {
        
        let attributes = ["a": "b"]
        let keychain = Keychain()
        
        XCTAssertThrowsError(try keychain.removeItemWithAttributes(attributes), "Should throw error when the operation fails") { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "swift.keychain.error")
            XCTAssertEqual(nsError.code, Int(errSecParam))
        }
    }
    
    func testFetchItemWithAttributes() throws {
        
        let item = MockGenericPasswordItem(accountName: "John_testFetchItemWithAttributes")
        let keychain = Keychain()
        var fetchedToken: String?
        var fetchedDate: NSDate?
        
        try keychain.insertItemWithAttributes(item.attributesToSave)
        
        XCTAssertNoThrow(try keychain.fetchItemWithAttributes(item.attributesForFetch), "Should fetch the keychain item from the Keychain")
        if let fetchedItem = try keychain.fetchItemWithAttributes(item.attributesForFetch) {
            
            XCTAssertNoThrow(try item.dataFromAttributes(fetchedItem), "Should get the item data from attributes")
            if let data = try item.dataFromAttributes(fetchedItem) {
            
                fetchedToken = data["token"] as? String
                fetchedDate = data["date"] as? NSDate
            }
        }
        
        XCTAssertEqual(fetchedToken, "123456", "Should return the keychain item data.token")
        XCTAssertEqual(fetchedDate, NSDate(timeIntervalSince1970: 123456), "Should return the keychain item data.date")
    }
    
    func testFetchItemWithAttributesThrowsUnexpectedClassError() throws {
        
        let item = MockGenericPasswordItemMisconfigured(accountName: "John_testFetchItemWithAttributesThrowsUnexpectedClassError")
        let keychain = Keychain()
        try keychain.insertItemWithAttributes(item.attributesToSave)
        
        if let fetchedItem = try keychain.fetchItemWithAttributes(item.attributesForFetch) {
            XCTAssertThrowsError(try item.dataFromAttributes(fetchedItem), "Should throw error when the operation fails") { error in
                let nsError = error as NSError
                XCTAssertEqual(nsError.domain, NSCocoaErrorDomain)
                XCTAssertEqual(nsError.code, 4864)
            }
        }
    }
    
    func testFetchItemWithAttributesThrowsError() {
        
        let attributes = ["a": "b"]
        let keychain = Keychain()
        
        XCTAssertThrowsError(try keychain.fetchItemWithAttributes(attributes),  "Should throw error when the operation fails") { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "swift.keychain.error")
            XCTAssertEqual(nsError.code, Int(errSecParam))
        }
    }
    
    func testFetchItemWithAttributesReturnsNilIfResultIsNotADictionary() throws {
        
        let item = MockGenericPasswordItem(accountName: "John_testFetchItemWithAttributesReturnsNilIfResultIsNotADictionary")
        let keychain = Keychain()
        
        try keychain.insertItemWithAttributes(item.attributes)
        
        let result = try keychain.fetchItemWithAttributes(item.attributes)
        
        XCTAssertNil(result, "Should return nil if the result is not a dictionary")
    }
}
