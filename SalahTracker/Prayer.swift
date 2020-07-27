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
//    var id:Int?
//    var date:Date?
//    var status:String?
//
//    init(id_:Int, date_:Date, status_:String) {
//        id = id_
//        date = date_
//        status = status_
//    }
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var status = ""
}
