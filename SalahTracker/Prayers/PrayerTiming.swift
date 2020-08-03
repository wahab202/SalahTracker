//
//  PrayerTiming.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/29/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import Foundation

class PrayerTiming: Codable {
    var Imsak:String = ""
    var Sunrise:String = ""
    var Asr:String = ""
    var Midnight:String = ""
    var Dhuhr:String = ""
    var Maghrib:String = ""
    var Sunset:String = ""
    var Fajr:String = ""
    var Isha:String = ""
    
    func formatTiming(){
        Imsak = String(Imsak.prefix(5))
        Sunrise = String(Sunrise.prefix(5))
        Asr = String(Asr.prefix(5))
        Midnight = String(Midnight.prefix(5))
        Dhuhr = String(Dhuhr.prefix(5))
        Maghrib = String(Maghrib.prefix(5))
        Sunset = String(Sunset.prefix(5))
        Fajr = String(Fajr.prefix(5))
        Isha = String(Isha.prefix(5))
    }
    
    func getTimingByDateArray() -> [Date] {
        let times = [
            Calendar.current.date(bySettingHour: Int(String((self.Fajr.prefix(2))))!, minute: Int(String((self.Fajr.suffix(2))))!, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: Int(String((self.Sunrise.prefix(2))))!, minute: Int(String((self.Sunrise.suffix(2))))!, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: Int(String((self.Dhuhr.prefix(2))))!, minute: Int(String((self.Dhuhr.suffix(2))))!, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: Int(String((self.Asr.prefix(2))))!, minute: Int(String((self.Asr.suffix(2))))!, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: Int(String((self.Maghrib.prefix(2))))!, minute: Int(String((self.Maghrib.suffix(2))))!, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: Int(String((self.Sunset.prefix(2))))!, minute: Int(String((self.Sunset.suffix(2))))!, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: Int(String((self.Isha.prefix(2))))!, minute: Int(String((self.Isha.suffix(2))))!, second: 0, of: Date())!,
        ]
        return times
    }
}
