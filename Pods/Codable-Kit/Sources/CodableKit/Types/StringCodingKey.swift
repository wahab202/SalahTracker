//
//  Example.swift
//  CodableKit
//
//  Created by Zonily Jame Pesquera on 13/02/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

/// A generic `String` based `CodingKey` implementation.
public struct StringCodingKey: CodingKey {
    /// `CodingKey` conformance.
    public var stringValue: String

    /// `CodingKey` conformance.
    public var intValue: Int? {
        return Int(self.stringValue)
    }

    /// Creates a new `StringCodingKey`.
    public init(_ string: String) {
        self.stringValue = string
    }

    /// `CodingKey` conformance.
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    /// `CodingKey` conformance.
    public init?(intValue: Int) {
        self.stringValue = intValue.description
    }
}

extension StringCodingKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

