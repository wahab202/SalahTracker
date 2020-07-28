//
//  Prayer.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/27/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import Foundation
import RealmSwift

class Prayer: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var status = 0
}
