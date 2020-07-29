//
//  TodayScreenViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/24/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import RealmSwift

enum PrayType: Int {
    case prayed = 0
    case qaza = 1
    case due = 2
    case noRecord = 3
}

class TodayScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let prayerNamesArray = ["Fajr","Dhuhr","Asr","Maghrib","Isha"]
    let dateFormatter = DateFormatter()
    var prayerTimes = [Date()]
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    let currentTime = Date()
    let timings = PrayerTiming()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        usernameLabel.text = "Hi, " + (defaults.string(forKey: "Name") ?? "")
        dateFormatter.dateFormat = "hh:mm aa"
        // The mothod below uses closure as a completion handler to handle the async request to prayer timing API
        NetworkManager.getPrayerTimingsFromAPI(method: RequestMethod.alamofire) { (timings) in
            timings?.formatTiming() // Removes extra characters (time format ) from the string for easier subscripting
            self.prayerTimes.removeAll() //Empty the array to fill it again with prayer times
            self.prayerTimes = [
                Calendar.current.date(bySettingHour: Int(String((timings?.Fajr.prefix(2))!))!, minute: Int(String((timings?.Fajr.suffix(2))!))!, second: 0, of: Date())!,
                Calendar.current.date(bySettingHour: Int(String((timings?.Dhuhr.prefix(2))!))!, minute: Int(String((timings?.Dhuhr.suffix(2))!))!, second: 0, of: Date())!,
                Calendar.current.date(bySettingHour: Int(String((timings?.Asr.prefix(2))!))!, minute: Int(String((timings?.Asr.suffix(2))!))!, second: 0, of: Date())!,
                Calendar.current.date(bySettingHour: Int(String((timings?.Maghrib.prefix(2))!))!, minute: Int(String((timings?.Maghrib.suffix(2))!))!, second: 0, of: Date())!,
                Calendar.current.date(bySettingHour: Int(String((timings?.Isha.prefix(2))!))!, minute: Int(String((timings?.Isha.suffix(2))!))!, second: 0, of: Date())!,
            ]
            self.tableView.reloadData()
        }
    }
    
    @IBAction func resetPrayers(_ sender: UIButton) {
        try! realm.write {
          realm.deleteAll()
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var status = getPrayerStatusFromDatabase(id: prayerNamesArray[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayPrayerTableViewCell.identifier) as! TodayPrayerTableViewCell
        cell.todayPrayerLabel.text = prayerNamesArray[indexPath.row]
        if prayerTimes.count > 1 {
            if currentTime < prayerTimes[indexPath.row] {
                status = PrayType.due
            }
        }
        switch status {
        case .prayed:
            cell.setStatus(status: PrayType.prayed, dueTime: "")
        case .qaza:
            cell.setStatus(status: PrayType.qaza, dueTime: "")
        case .noRecord:
            cell.setStatus(status: PrayType.noRecord, dueTime: "")
        case .due:
            cell.setStatus(status: PrayType.due, dueTime: dateFormatter.string(from: prayerTimes[indexPath.row]))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func getPrayerStatusFromDatabase(id:String) -> PrayType {
        let prayerList = realm.objects(Prayer.self)
        let prayer = prayerList.filter { $0.id == id }.filter { Calendar.current.isDate($0.date, inSameDayAs:Date())}
        return PrayType(rawValue: prayer.first?.status ?? 3) ?? PrayType.noRecord
    }

}
