//
//  Decodable.swift
//  CodableKit
//
//  Created by z on 20/09/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public extension Decodable {
    /// Directly instantiate a Decodable object from `Data`
    /// - Parameter data: The data containing the object that will be parsed
    /// - Parameter decoder: `AnyDecoder` default value is `JSONDecoder()`
    init(_ data: Data, decoder: AnyDecoder = JSONDecoder()) throws {
        self = try decoder.decode(Self.self, from: data)
    }
    
    /// Directly instantiate a Decodable object from a json `String`
    /// - Parameter json: The json string that will be used
    /// - Parameter encoding: The encoding for converting the string to data
    /// - Parameter decoder: `AnyDecoder` default value is `JSONDecoder()`
    init(_ json: String, using encoding: String.Encoding = .utf8, decoder: AnyDecoder = JSONDecoder()) throws {
        let data = try json.data(using: encoding).unwrap()
        try self.init(data, decoder: decoder)
    }
    
    /// Directly instantiate a Decodable object from a fileUrl `URL`
    /// - Parameter url: The file url containing the data
    /// - Parameter decoder: `AnyDecoder` default value is `JSONDecoder()`
    init(_ url: URL, decoder: AnyDecoder = JSONDecoder()) throws {
        let data = try Data(contentsOf: url)
        try self.init(data, decoder: decoder)
    }
}
