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
    case jamat = 2
}

class TodayScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let prayerNamesArray = ["Fajr","Dhuhr","Asr","Maghrib","Isha"]
    let formatter = DateFormatter()
    let prayerTimes = [
        Calendar.current.date(bySettingHour: 5, minute: 00, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 11, minute: 10, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 19, minute: 30, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 21, minute: 00, second: 0, of: Date())!]
    var realm = try! Realm()
    let defaults = UserDefaults.standard
    let currentTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        usernameLabel.text = "Hi, " + (defaults.string(forKey: "Name") ?? "")
        formatter.dateFormat = "hh:mm aa"
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
        let status = getPrayerStatusFromDatabase(id: prayerNamesArray[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayPrayerTableViewCell.identifier) as! TodayPrayerTableViewCell
        cell.todayPrayerLabel.text = prayerNamesArray[indexPath.row]
        if currentTime < prayerTimes[indexPath.row] {
            cell.setStatusToDueInTime(time: formatter.string(from: prayerTimes[indexPath.row]))
            return cell
        }
        PrayType(rawValue: 0)
        if status == PrayType.prayed {
            cell.setStatus(status: status)
        }
        if status == "Prayed" {
            cell.setStatusToPrayed()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func getPrayerStatusFromDatabase(id:String) -> String {
        let prayerList = realm.objects(Prayer.self)
        let prayer = prayerList.filter { $0.id == id }
        return prayer.first?.status ?? "NIL"
    }

}
