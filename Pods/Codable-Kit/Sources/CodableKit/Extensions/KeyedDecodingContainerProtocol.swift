//
//  KeyedDecodingContainer.swift
//  CodableKit
//
//  Created by z on 20/09/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public extension KeyedDecodingContainerProtocol {
    
    // Decodable Objects
    
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
        return try self.decodeIfPresent(T.self, forKey: key)
    }
    
    func decode<T: Decodable>(forKey key: Key, default defaultExpression: @autoclosure () -> T) throws -> T {
        return try self.decodeIfPresent(forKey: key) ?? defaultExpression()
    }
    
    // Collections
    
    func decode(forKey key: Key) throws -> Any {
        return try self.decode(Any.self, forKey: key)
    }
    
    func decode(forKey key: Key) throws -> [Any] {
        return try self.decode([Any].self, forKey: key)
    }
    
    func decode(forKey key: Key) throws -> [String: Any] {
        return try self.decode([String: Any].self, forKey: key)
    }
    
    
    func decodeIfPresent(forKey key: Key) throws -> Any? {
        return try self.decodeIfPresent(Any.self, forKey: key)
    }
    
    func decodeIfPresent(forKey key: Key) throws -> [Any]? {
        return try self.decodeIfPresent([Any].self, forKey: key)
    }
    
    func decodeIfPresent(forKey key: Key) throws -> [String: Any]? {
        return try self.decodeIfPresent([String: Any].self, forKey: key)
    }
    
    
    func decode(forKey key: Key, default defaultExpression: @autoclosure () -> Any) throws -> Any {
        return try self.decodeIfPresent(Any.self, forKey: key) ?? defaultExpression()
    }
    
    func decode(forKey key: Key, default defaultExpression: @autoclosure () -> [Any]) throws -> [Any] {
        return try self.decodeIfPresent([Any].self, forKey: key) ?? defaultExpression()
    }
    
    func decode(forKey key: Key, default defaultExpression: @autoclosure () -> [String: Any]) throws -> [String: Any] {
        return try self.decodeIfPresent([String: Any].self, forKey: key) ?? defaultExpression()
    }
}

// MARK: - Normal

public extension KeyedDecodingContainerProtocol {
    func decode(_ type: Any.Type, forKey key: Key) throws -> Any {
        var values = try self.nestedUnkeyedContainer(forKey: key)
        return try values.decode(type)
    }
    
    func decodeIfPresent(_ type: Any.Type, forKey key: Key) throws -> Any? {
        guard self.contains(key), !(try self.decodeNil(forKey: key)) else { return nil }
        return try self.decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: Key) throws -> [Any] {
        var values = try self.nestedUnkeyedContainer(forKey: key)
        return try values.decode(type)
    }
    
    func decode(_ type: [String: Any].Type, forKey key: Key) throws -> [String: Any] {
        let values = try self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        return try values.decode(type)
    }
    
    func decodeIfPresent(_ type: [Any].Type, forKey key: Key) throws -> [Any]? {
        guard self.contains(key), !(try self.decodeNil(forKey: key)) else { return nil }
        return try self.decode(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: [String: Any].Type, forKey key: Key) throws -> [String: Any]? {
        guard self.contains(key), !(try self.decodeNil(forKey: key)) else { return nil }
        return try self.decode(type, forKey: key)
    }
    
    internal func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary: [String: Any] = [:]
        for key in self.allKeys {
            if try self.decodeNil(forKey: key) {
                dictionary[key.stringValue] = NSNull()
            } else if let bool = try? self.decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = bool
            } else if let string = try? self.decode(String.self, forKey: key) {
                dictionary[key.stringValue] = string
            } else if let int = try? self.decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = int
            } else if let double = try? self.decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = double
            } else if let dict = try? self.decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = dict
            } else if let array = try? self.decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = array
            }
        }
        return dictionary
    }
}

private extension UnkeyedDecodingContainer {
    mutating func decode(_ type: Any.Type) throws -> Any {
        if try self.decodeNil() {
            return NSNull()
        } else if let int = try? self.decode(Int.self) {
            return int
        } else if let bool = try? self.decode(Bool.self) {
            return bool
        } else if let double = try? self.decode(Double.self) {
            return double
        } else if let string = try? self.decode(String.self) {
            return string
        } else if let values = try? self.nestedContainer(keyedBy: AnyCodingKey.self),
            let element = try? values.decode([String: Any].self) {
            return element
        } else if var values = try? self.nestedUnkeyedContainer(),
            let element = try? values.decode([Any].self) {
            return element
        }
        return NSNull()
    }
    
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var elements: [Any] = []
        while !self.isAtEnd {
            if try self.decodeNil() {
                elements.append(NSNull())
            } else if let int = try? self.decode(Int.self) {
                elements.append(int)
            } else if let bool = try? self.decode(Bool.self) {
                elements.append(bool)
            } else if let double = try? self.decode(Double.self) {
                elements.append(double)
            } else if let string = try? self.decode(String.self) {
                elements.append(string)
            } else if let values = try? self.nestedContainer(keyedBy: AnyCodingKey.self),
                let element = try? values.decode([String: Any].self) {
                elements.append(element)
            } else if var values = try? self.nestedUnkeyedContainer(),
                let element = try? values.decode([Any].self) {
                elements.append(element)
            }
        }
        return elements
    }
}
