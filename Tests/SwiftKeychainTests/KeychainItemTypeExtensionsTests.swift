//
//  KeychainItemTypeExtensionsTests.swift
//  Keychain
//
//  Created by Yanko Dimitrov on 2/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import XCTest
@testable import SwiftKeychain

class KeychainItemTypeExtensionsTests: XCTestCase {
    
    func testDefaultAccessMode() {
        
        let item = MockKeychainItem()
        
        XCTAssertEqual(item.accessMode, String(kSecAttrAccessibleWhenUnlocked), "Should return the default access mode")
    }
    
    func testAttributesToSave() throws {
        
        let item = MockKeychainItemSimple()
        
        let expectedSecClass = String(kSecClassGenericPassword)
        let expectedData = try NSKeyedArchiver.archivedData(withRootObject: [
            "token": "123456"
        ], requiringSecureCoding: true)
        
        let attriburesToSave = item.attributesToSave
        
        let secClass = attriburesToSave[String(kSecClass)] as? String ?? ""
        let secValueData = attriburesToSave[String(kSecValueData)] as? Data ?? Data()
        
        XCTAssertEqual(secClass, expectedSecClass, "Should contain the returned attributes")
        XCTAssertEqual(secValueData, expectedData, "Should contain the key data")
    }
    
    func testDataFromAttributes() throws {
        
        let item = MockKeychainItem()
        let attributes = item.attributesToSave
        var token: String?
        var date: NSDate?
        
        if let data = try item.dataFromAttributes(attributes) {
            
            token = data["token"] as? String
            date = data["date"] as? NSDate
        }
        
        XCTAssertEqual(token, "123456", "Should return the item data.token")
        XCTAssertEqual(date?.timeIntervalSince1970, 123456, "Should return the item data.date")
    }
    
    func testDataFromAttributesWillReturnNilWhenThereIsNoData() throws {
        
        let item = MockKeychainItem()
        let attributes = ["a": "b"]
        
        let data = try item.dataFromAttributes(attributes)
        
        XCTAssertNil(data, "Should return nil if there is no data")
    }
    
    func testDataFromAttributesWillReturnNilWhenDataIsNotDictionary() throws {
        
        let item = MockKeychainItem()
        let itemData = try NSKeyedArchiver.archivedData(withRootObject: NSDate(), requiringSecureCoding: true)
        let attributes = [String(kSecValueData): itemData]
        let data = try item.dataFromAttributes(attributes)
        
        XCTAssertNil(data, "Should return nil if the data is not a dictionary")
    }
    
    
    func testAttributesForFetch() {
        
        let item = MockKeychainItem()
        let attributes = item.attributesForFetch
        
        let secReturnData = attributes[String(kSecReturnData)] as? Bool ?? false
        let secReturnAttributes = attributes[String(kSecReturnAttributes)] as? Bool ?? false
        
        XCTAssertEqual(secReturnData, true, "Should contain true in kSecReturnData")
        XCTAssertEqual(secReturnAttributes, true, "Should contain true in kSecReturnAttributes")
    }
    
    func testSaveInKeychain() throws {
        
        let keychain = MockKeychain()
        let item = MockKeychainItem()
        
        try item.saveInKeychain(keychain)
        
        XCTAssertEqual(keychain.isInsertCalled, true, "Should call the Keychain to insert the item")
    }
    
    func testRemoveFromKeychain() throws {
        
        let keychain = MockKeychain()
        let item = MockKeychainItem()
        
        try item.removeFromKeychain(keychain)
        
        XCTAssertEqual(keychain.isRemoveCalled, true, "Should call the keychain to remove the item")
    }
    
    func testFetchFromKeychain() throws {
        
        let keychain = MockKeychain()
        var item = MockKeychainItem()
        
        let result = try item.fetchFromKeychain(keychain)
        
        let token = result.data["token"] as? String
        let date = result.data["date"] as? NSDate
        
        XCTAssertEqual(token, "123456", "Should populate the item's data.token from the Keychain")
        XCTAssertEqual(date, NSDate(timeIntervalSince1970: 123456), "Should populate the item's data.date from the Keychain")
    }
}
