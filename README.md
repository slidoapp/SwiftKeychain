# SwiftKeychain

> Swift wrapper for working with the Keychain API implemented with protocol oriented programming.

## Abstract

You create an implementation of the `KeychainGenericPasswordType` protocol that encapsulates the data that you want to store in the `Keychain`. Most of the implementation is done for you by using default protocol implementations, such as setting the default service name and access mode (`kSecAttrAccessibleWhenUnlocked`).

Then you call the `KeychainItemType` methods to save, remove or fetch the item from the provided as argument `KeychainServiceType` protocol implementation.

![SwiftKeychain Protocols](Resources/Protocols.png)

Let's say we want to store the access token and username for an Instagram account in the Keychain:

```swift
struct InstagramAccount: KeychainGenericPasswordType {
    let accountName: String
    let token: String
    var data = KeychainData()
    
    var dataToStore: KeychainData {
        return ["token": token]
    }
    
    var accessToken: String? {
        return data["token"] as? String
    }
    
    init(name: String, accessToken: String = "") {
        accountName = name
        token = accessToken
    }
}
```

In `var dataToStore: KeychainData` you return the Dictionary (`KeychainData` is just an alias for `[String: any Sendable]`) that you want to be saved in the Keychain and when you fetch the item from the Keychain its data will be populated in your `var data: KeychainData` property.

### Save Item
```swift
let newAccount = InstagramAccount(name: "John", accessToken: "123456")

do {
    try newAccount.saveInKeychain()
} catch {
    print(error)
}
```
> [!NOTE]  
> The provided implementation of the `KeychainServiceType` protocol will replace the item if it already exists in the Keychain database.

### Remove Item
```swift
let account = InstagramAccount(name: "John")

do {
    try account.removeFromKeychain()
} catch {
    print(error)
}
```

### Fetch Item
```swift
var account = InstagramAccount(name: "John")

do {
    try account.fetchFromKeychain()
    
    if let token = account.accessToken {
        print("name: \(account.accountName), token: \(token)")
    }
} catch {
    print(error)
}
```

### Support for classes
By default, stored data supports only value types such as strings and numbers. If you want to store objects of any class (for example, `NSDate`) in the Keychain, you need to implement the `storedClasses` property of the `KeychainItemType` protocol. In this property, you must explicitly list all the class types that will be stored:

```swift
struct InstagramAccount: KeychainGenericPasswordType {
    let accountName: String
    let token: String
    let tokenDate: NSDate
    var data = KeychainData()
    
    var dataToStore: KeychainData {
        return [
            "token": token,
            "tokenDate": tokenDate
        ]
    }
        
    var storedClasses: [AnyClass] {
        return [NSDate.self]
    }
    
    var accessToken: String? {
        return data["token"] as? String
    }

    var accessTokenDate: NSDate? {
        return data["tokenDate"] as? NSDate
    }
    
    init(name: String, accessToken: String, accessTokenDate: NSDate) {
        accountName = name
        token = accessToken
        tokenDate = accessTokenDate
    }
}
```


## Installation

**SwiftKeychain** package requires Swift 5.5 and supports macOS, iOS, watchOS, tvOS and visionOS.

### Install

```swift
.package(url: "https://github.com/slidoapp/SwiftKeychain.git", from: "2.0.0")
```

## License
SwiftKeychain is released under the MIT license. See the [LICENSE.txt](LICENSE.txt) file for more info.
