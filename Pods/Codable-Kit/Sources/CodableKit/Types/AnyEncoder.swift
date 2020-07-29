//
//  AnyEncoder.swift
//  CodableKit
//
//  Created by Zonily Jame Pesquera on 13/02/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public protocol AnyEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: AnyEncoder {}
extension PropertyListEncoder: AnyEncoder {}
