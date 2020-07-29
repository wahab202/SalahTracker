//
//  Encodable.swift
//  CodableKit
//
//  Created by z on 20/09/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public extension Encodable {
    func encoded(using encoder: AnyEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    func jsonData(_ encoder: AnyEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    func json(encoder: AnyEncoder = JSONEncoder(), encoding: String.Encoding = .utf8) throws -> String {
        let data = try self.jsonData(encoder)
        return try String(data: data, encoding: encoding).unwrap()
    }
}
