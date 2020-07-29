//
//  FileDecodingError.swift
//  CodableKit
//
//  Created by Zonily Jame Pesquera on 13/02/2019.
//  Copyright © 2019 com.kuyazee. All rights reserved.
//

import Foundation

public enum FileDecodingError: Swift.Error {
    case cannotFindFile(File)
    case invalidDataForFile(File)
}
