//
//  UserDefaults+Codable.swift
//  CodableKit
//
//  Created by z on 20/09/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public extension UserDefaults {
    func setCodable<T: Codable>(_ value: T?, forKey key: String, encoder: AnyEncoder = JSONEncoder()) {
        guard let value = value else {
            self.set(nil, forKey: key)
            self.synchronize()
            return
        }
        do {
            let data = try encoder.encode(value)
            self.set(data, forKey: key)
        } catch {
            self.set(nil, forKey: key)
        }
        self.synchronize()
    }
    
    func codableObject<T: Codable>(forKey key: String, decoder: AnyDecoder = JSONDecoder()) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }
        
        return try? decoder.decode(data)
    }
}
