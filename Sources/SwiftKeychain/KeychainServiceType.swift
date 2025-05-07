//
//  KeychainItemType.swift
//  SwiftKeychain
//
//  Created by Dominik Paľo on 07/05/2025.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//  Copyright © 2025 Cisco Systems, Inc.
//

import Foundation

public protocol KeychainServiceType {
    
    func insertItemWithAttributes(_ attributes: KeychainAttributes) throws
    func removeItemWithAttributes(_ attributes: KeychainAttributes) throws
    func fetchItemWithAttributes(_ attributes: KeychainAttributes) throws -> KeychainItem?
}
