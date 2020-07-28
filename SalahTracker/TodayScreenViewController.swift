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
    let prayerTimes = [
        Calendar.current.date(bySettingHour: 5, minute: 00, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 11, minute: 10, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 19, minute: 30, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 21, minute: 00, second: 0, of: Date())!]
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    let currentTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        usernameLabel.text = "Hi, " + (defaults.string(forKey: "Name") ?? "")
        dateFormatter.dateFormat = "hh:mm aa"
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
        if currentTime < prayerTimes[indexPath.row] {
            status = PrayType.due
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
