# CodableKit

[![LinkedIn](https://img.shields.io/badge/LinkedIn-zjgpesquera-blue.svg)](https://www.linkedin.com/in/zjgpesquera/)
[![Github](https://img.shields.io/badge/Github-kuyazee-blue.svg)](https://github.com/kuyazee)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-supported-red.svg)](http://cocoapods.org)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange)](https://swift.org)

A Swiftier [Codable](https://developer.apple.com/documentation/swift/codable) experience.
__CodableKit__ is a library built to extend Swift's __Codable__.

## Features

- [x] Decode without specifying type 
- [x] Decode/Encode `Array<Any>`
- [x] Decode/Encode `Dictionary<String, Any>`
- [x] Use Model initializers instead of using `Decoder.decode(...)` methods
- [ ] XML Custom Decoder/Encoder CodableKit/[XMLParsing](https://github.com/ShawnMoore/XMLParsing)

## Requirements

- iOS 9.0+
- Swift 5.1+

## Installation

__CodableKit__ is available through the dependency manager [CocoaPods](http://cocoapods.org).

To install the CodableKit via cocoapods, simply use the add this in your podfile and then run `pod install`

```Cocoapods
pod 'Codable-Kit'
```

## Usage

Import CodableKit at the top of the Swift file that you will need to encode/decode objects

```swift
import Codable_Kit
```

All your interactions with encoding/decoding will work with Swift's `Codable` protocol. This library is just a collection of extensions for improving the functionality of `Codable`.

Normally decoding an object would require you to specify the type of the object you need to decode.

```swift
let decoder = JSONDecoder()
do {
    let user = try decoder.decode(User.self, from userData)
} catch {
    print(error)
}
```

With the extensions added in this framework you can now decode without specifying the data type on the method itself.

```swift
let decoder = JSONDecoder()
do {
    let user: User = try decoder.decode(userData)
    // or
    let user2 = try decoder.decode(userData) as User
} catch {
    print(error)
}
```

Additionally you can also instantiate `Decodable` conforming objects directly 

```swift
struct User: Decodable {
    let id: String
    let firstName: String
    let lastName: String
}

do {
    let user = try User(data)
    let user2 = try User(string)
    let user3 = try User(fileUrl)
} catch {
    print(error)
}
```

---

Another added funcionality of this framework is support for Decoding/Encoding `[String: Any]` and `[Any]` types

```swift
let decoder = JSONDecoder()
do {
    let dict = try decoder.decode([String: Any].self, from data)
    let dict2: [String: Any] = try decoder.decode(data)
    let dict3 = try decoder.decode(data) as [String: Any]
    
    let array = try decoder.decode([Any].self, from data)
    let array2: [Any] = try decoder.decode(data)
    let array3 = try decoder.decode(data) as [Any]
} catch {
    print(error)
}
```

This will also work on Models who conform to `Codable`/`Decodable`

```swift 
struct FooModel: Codable {
    let dict: [String: Any]
    let array: [Any]
    let optionalDict: [String: Any]?
    let optionalArray: [Any]?

    enum CodingKeys: String, CodingKey {
        case dict
        case array
        case optionalDict
        case optionalArray
    }
}

let decoder = JSONDecoder()
do {
    let foo: FooModel = try decoder.decode(data)
    print("dict:", foo.dict)
    print("array:", foo.array)
    print("optionalDict:", foo.optionalDict)
    print("optionalArray:", foo.optionalArray)
} catch {
    print(error)
}
```

---

This framework can also decode files from the app's bundle


```swift
let decoder = FileDecoder(decoder: JSONDecoder(), bundle: .main, fileManager: .default)
do {
    let user = try decoder.decode(User.self, from: File(name: "user", type: "json"))
    
    let user2: User = try decoder.decode(File(name: "user", type: "json"))
} catch {
    print(error)
}
```

## Licenses

All source code is licensed under the [MIT License](https://github.com/kuyazee/CodableKit/blob/master/LICENSE).
