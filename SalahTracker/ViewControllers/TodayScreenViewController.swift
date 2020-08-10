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
    case notYetDue = 2
    case noRecord = 3
}

class TodayScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectionFailedView: UIView!
    @IBOutlet weak var retryApiRequestButton: UIButton!
    
    let prayerNamesArray = ["Fajr","Sunrise ☀️","Dhuhr","Asr","Maghrib","Sunset 🌙","Isha"]
    let dateFormatter = DateFormatter()
    var prayerTimes: [Date]!
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    let currentTime = Date()
    let timings = PrayerTiming()
    var errorStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        usernameLabel.text = "Hi, " + (defaults.string(forKey: "Name") ?? "")
        dateFormatter.dateFormat = "hh:mm aa"
        getPrayerTimingsFromApi()
    }
    
    func getPrayerTimingsFromApi() {
        // The mothod below uses closure as a completion handler to handle the async request to prayer timing API
        NetworkManager.getPrayerTimingsFromAPI(method: RequestMethod.alamofire) { (timings,connectionError) in
            if connectionError == 0 {
                timings?.removeExtraCharacters() // Removes extra characters (time format) from the string for easier subscripting
                self.prayerTimes = timings?.getTimingByDateArray()
                self.connectionFailedView.isHidden = true
                self.errorStatus = 0
            } else {
                self.errorStatus = 1
                self.prayerTimes = [Date()]
                self.retryApiRequestButton.setTitle("Retry", for: .normal)
                self.retryApiRequestButton.isEnabled = true
                self.connectionFailedView.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func retryApiRequestButtonPressed(_ sender: UIButton) {
        retryApiRequestButton.setTitle("Retrying", for: .normal)
        retryApiRequestButton.isEnabled = false
        errorStatus = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0 ) {
            self.getPrayerTimingsFromApi()
        }
    }
    
    @IBAction func resetPrayersButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Prayers", message: "How many prayers do you want to reset ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Reset All", style: UIAlertAction.Style.default, handler: { (action) in
            self.resetAllPrayersFromDatabase()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Reset Today", style: UIAlertAction.Style.default, handler: { (action) in
            self.resetTodayPrayersFromDatabase()
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
        
    }
    
    func resetAllPrayersFromDatabase(){
        try! self.realm.write {
            self.realm.deleteAll()
        }
        self.tableView.reloadData()
    }
    
    func resetTodayPrayersFromDatabase(){
        let prayersToBeDeleted = realm.objects(Prayer.self).filter { Calendar.current.isDate($0.date, inSameDayAs:Date())}
        try! realm.write {
            realm.delete(prayersToBeDeleted)
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var status = getTodaysPrayerStatusFromDatabase(for: prayerNamesArray[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayPrayerTableViewCell.identifier) as! TodayPrayerTableViewCell
        cell.todayPrayerLabel.text = prayerNamesArray[indexPath.row]
        if prayerTimes == nil {
            cell.statusLabel.text = errorStatus == 0 ? "Loading..." : ""
            cell.statusLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cell.selectionButtonsView.isHidden = true
            return cell
        }
        if indexPath.row == 1 || indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCellTodayViewController
            cell.timeLabel.text = prayerNamesArray[indexPath.row]
            cell.iconLabel.text = errorStatus == 0 ? dateFormatter.string(from: prayerTimes[indexPath.row]) : ""
            cell.setColor(label: prayerNamesArray[indexPath.row])
            return cell
        }
        if errorStatus == 0 {
            if status == PrayType.noRecord {
                if currentTime < prayerTimes[indexPath.row] {
                    status = PrayType.notYetDue
                }
            }
        }
        switch status {
        case .prayed:
            cell.setStatus(status: PrayType.prayed, dueTime: "")
        case .qaza:
            cell.setStatus(status: PrayType.qaza, dueTime: "")
        case .noRecord:
            cell.setStatus(status: PrayType.noRecord, dueTime: "")
        case .notYetDue:
            cell.setStatus(status: PrayType.notYetDue, dueTime: errorStatus == 0 ? dateFormatter.string(from: prayerTimes[indexPath.row]) : "")
        }
        return cell
    }
    
    func getTodaysPrayerStatusFromDatabase(for prayerName:String) -> PrayType {
        let prayerList = realm.objects(Prayer.self)
        let prayer = prayerList.filter { $0.id == prayerName }.filter { Calendar.current.isDate($0.date, inSameDayAs:Date())}
        return PrayType(rawValue: prayer.first?.status ?? 3) ?? PrayType.noRecord
    }

}
