//
//  AnyFileDecoder.swift
//  CodableKit
//
//  Created by z on 20/09/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public protocol AnyFileDecoder {
    func decode<T: Decodable>(_ type: T.Type, from file: File) throws -> T
    
    func decode<T: Decodable>(_ file: File) throws -> T
}

public extension AnyFileDecoder {
    func decode<T>(_ file: File) throws -> T where T : Decodable {
        return try self.decode(T.self, from: file)
    }
}


