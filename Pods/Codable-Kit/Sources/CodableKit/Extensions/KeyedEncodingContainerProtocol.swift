//
//  KeyedEncodingContainerProtocol.swift
//  CodableKit
//
//  Created by z on 20/09/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public extension KeyedEncodingContainerProtocol {
    mutating func encode(_ value: [String: Any], forKey key: Key) throws {
        var container = self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        try container.encode(value)
    }
    
    mutating func encode(_ value: [Any], forKey key: Key) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }
    
    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: Key) throws {
        if let value = value {
            var container = self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
            try container.encode(value)
        } else {
            try self.encodeNil(forKey: key)
        }
    }
    
    mutating func encodeIfPresent(_ value: [Any]?, forKey key: Key) throws {
        if let value = value {
            var container = self.nestedUnkeyedContainer(forKey: key)
            try container.encode(value)
        } else {
            try self.encodeNil(forKey: key)
        }
    }
}

internal extension KeyedEncodingContainerProtocol where Key == AnyCodingKey {
    mutating func encode(_ value: [String: Any]) throws {
        for (k, v) in value {
            let key = AnyCodingKey(k)
            switch v {
            case is NSNull:
                try self.encodeNil(forKey: key)
            case let string as String:
                try self.encode(string, forKey: key)
            case let int as Int:
                try self.encode(int, forKey: key)
            case let bool as Bool:
                try self.encode(bool, forKey: key)
            case let double as Double:
                try self.encode(double, forKey: key)
            case let dict as [String: Any]:
                try self.encode(dict, forKey: key)
            case let array as [Any]:
                try self.encode(array, forKey: key)
            default:
                debugPrint("⚠️ Unsuported type!", v)
                continue
            }
        }
    }
}

//internal extension KeyedEncodingContainer where K == AnyCodingKey {
//    mutating func encode(_ value: [String: Any]) throws {
//        for (k, v) in value {
//            let key = AnyCodingKey(k)
//            switch v {
//            case is NSNull:
//                try self.encodeNil(forKey: key)
//            case let string as String:
//                try self.encode(string, forKey: key)
//            case let int as Int:
//                try self.encode(int, forKey: key)
//            case let bool as Bool:
//                try self.encode(bool, forKey: key)
//            case let double as Double:
//                try self.encode(double, forKey: key)
//            case let dict as [String: Any]:
//                try self.encode(dict, forKey: key)
//            case let array as [Any]:
//                try self.encode(array, forKey: key)
//            default:
//                debugPrint("⚠️ Unsuported type!", v)
//                continue
//            }
//        }
//    }
//}

private extension UnkeyedEncodingContainer {
    /// Encodes the given value.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encode(_ value: [Any]) throws {
        for v in value {
            switch v {
            case is NSNull:
                try self.encodeNil()
            case let string as String:
                try self.encode(string)
            case let int as Int:
                try self.encode(int)
            case let bool as Bool:
                try self.encode(bool)
            case let double as Double:
                try self.encode(double)
            case let dict as [String: Any]:
                try self.encode(dict)
            case let array as [Any]:
                var values = self.nestedUnkeyedContainer()
                try values.encode(array)
            default:
                debugPrint("⚠️ Unsuported type!", v)
            }
        }
    }
    
    /// Encodes the given value.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encode(_ value: [String: Any]) throws {
        var container = self.nestedContainer(keyedBy: AnyCodingKey.self)
        try container.encode(value)
    }
}
