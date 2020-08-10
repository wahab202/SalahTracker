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
            DatabaseManager.resetAllPrayersFromDatabase()
            alert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Reset Today", style: UIAlertAction.Style.default, handler: { (action) in
            DatabaseManager.resetTodayPrayersFromDatabase()
            alert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }))
        self.present(alert,animated: true,completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayerNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = DatabaseManager.getTodaysPrayerStatusFromDatabase(for: prayerNamesArray[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayPrayerTableViewCell.identifier) as! TodayPrayerTableViewCell
        cell.setupCell(index: indexPath.row, prayerNamesArray: prayerNamesArray, prayerTimes: prayerTimes, errorStatus: errorStatus, status: status, dateFormatter: dateFormatter)
        if indexPath.row == 1 || indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCellTodayViewController
            cell.setupCell(prayerTimes: prayerTimes, prayerNamesArray: prayerNamesArray, errorStatus: errorStatus, dateFormatter: dateFormatter, index: indexPath.row)
            return cell
        }
        return cell
    }
}
