//
//  NilError.swift
//  CodableKit
//
//  Created by Zonily Jame Pesquera on 25/03/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public struct NilError: Error {
    public let file: String
    public let line: Int
    public let column: Int
    public let function: String
}

extension Optional {
    public func unwrap(file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) throws -> Wrapped {
        return try unwrap(or: NilError(file: file, line: line, column: column, function: function))
    }

    public func unwrap(or error: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .some(let w): return w
        case .none: throw error()
        }
    }
}
