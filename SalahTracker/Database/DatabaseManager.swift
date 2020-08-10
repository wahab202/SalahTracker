//
//  DatabaseManager.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 8/10/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    static let realm = try! Realm()
    
    static func getTodaysPrayerStatusFromDatabase(for prayerName:String) -> PrayType {
        let prayerList = realm.objects(Prayer.self)
        let prayer = prayerList.filter { $0.id == prayerName }.filter { Calendar.current.isDate($0.date, inSameDayAs:Date())}
        return PrayType(rawValue: prayer.first?.status ?? 3) ?? PrayType.noRecord
    }
    
    static func getPrayersFromDatabase(ofDate date:Date) -> [Prayer] {
        let prayerList = realm.objects(Prayer.self)
        let prayers = prayerList.filter { Calendar.current.isDate($0.date, inSameDayAs: date)}
        return Array(prayers)
    }
    
    static func resetAllPrayersFromDatabase(){
        try! self.realm.write {
            self.realm.deleteAll()
        }
    }
    
    static func resetTodayPrayersFromDatabase(){
        let prayersToBeDeleted = realm.objects(Prayer.self).filter { Calendar.current.isDate($0.date, inSameDayAs:Date())}
        try! realm.write {
            realm.delete(prayersToBeDeleted)
        }
    }
    
}
