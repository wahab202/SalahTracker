//
//  TodayViewController.swift
//  NextPrayerDue
//
//  Created by Abdul Wahab on 8/7/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var prayerLabel: UILabel!
    @IBOutlet weak var timeOfPrayer: UILabel!
    
    let prayerNamesArray = ["Fajr","Sunrise ☀️","Dhuhr","Asr","Maghrib","Sunset 🌙","Isha"]
    let dateFormatter = DateFormatter()
    let defaults = UserDefaults.standard
    var apiLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "hh:mm aa"
        apiLink = "http://api.aladhan.com/v1/calendar?latitude="+defaults.string(forKey: "latitude")!+"&longitude="+defaults.string(forKey: "longitude")!+"&method="
        apiLink = apiLink + String(defaults.integer(forKey: "method")) + "&month="
        setNextPrayerTime()
    }
    
    func setNextPrayerTime()  {
        NetworkManager.getPrayerTimingsFromAPI(apiLink: apiLink, method: RequestMethod.alamofire) { (timings,connectionError) in
            if connectionError == 0 {
                timings?.removeExtraCharacters()
                let prayerTimes = timings?.getTimingByDateArray()
                let nextPrayerList = prayerTimes?.filter { Date()<$0 }
                let nextPrayerIndex = prayerTimes?.firstIndex(of: nextPrayerList?[0] ?? Date())
                self.prayerLabel.text = self.prayerNamesArray[(nextPrayerIndex ?? 0)] + " Starts At"
                self.timeOfPrayer.text = self.dateFormatter.string(from: nextPrayerList?[0] ?? Date())
            } else {
                self.prayerLabel.text = "Connection Error"
                self.timeOfPrayer.text = ""
            }
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
