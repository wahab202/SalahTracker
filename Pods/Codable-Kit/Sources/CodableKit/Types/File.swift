//
//  File.swift
//  CodableKit
//
//  Created by Zonily Jame Pesquera on 13/02/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public struct File {
    public let name: String?
    public let type: String?
    public let directory: String?
    public let localization: String?

    public init(name: String?, type: String?, directory: String? = nil, localization: String? = nil) {
        self.name = name
        self.type = type
        self.directory = directory
        self.localization = localization
    }
}
