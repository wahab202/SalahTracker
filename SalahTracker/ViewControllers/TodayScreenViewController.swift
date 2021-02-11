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
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let prayerNamesArray = ["Fajr","Sunrise ☀️","Dhuhr","Asr","Maghrib","Sunset 🌙","Isha"]
    let dateFormatter = DateFormatter()
    var prayerTimes: [Date]!
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    let currentTime = Date()
    let timings = PrayerTiming()
    var apiLink = ""
    var errorStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        dateFormatter.dateFormat = "hh:mm aa"
        locationLabel.text = "in " + defaults.string(forKey: "locality")!
        apiLink = "http://api.aladhan.com/v1/calendar?latitude="+defaults.string(forKey: "latitude")!+"&longitude="+defaults.string(forKey: "longitude")!+"&method="
        apiLink = apiLink + String(defaults.integer(forKey: "method")) + "&month="
        getPrayerTimingsFromApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        if defaults.integer(forKey: "needsRefresh") == 1 {
            locationLabel.text = "in " + defaults.string(forKey: "locality")!
            apiLink = "http://api.aladhan.com/v1/calendar?latitude="+defaults.string(forKey: "latitude")!+"&longitude="+defaults.string(forKey: "longitude")!+"&method="
            apiLink = apiLink + String(defaults.integer(forKey: "method")) + "&month="
            getPrayerTimingsFromApi()
        }
    }
    
    func getPrayerTimingsFromApi() {
        // The mothod below uses closure as a completion handler to handle the async request to prayer timing API
        NetworkManager.getPrayerTimingsFromAPI(apiLink: apiLink,method: RequestMethod.alamofire) { (timings,connectionError) in
            if connectionError == 0 {
                timings?.removeExtraCharacters() // Removes extra characters (time format) from the string for easier subscripting
                self.prayerTimes = timings?.getTimingByDateArray()
                self.errorStatus = 0
            } else {
                self.errorStatus = 1
                self.prayerTimes = [Date()]
                self.handleConnectionError()
            }
            self.tableView.reloadData()
        }
    }
    
    func handleConnectionError() {
        let alert = UIAlertController(title: "Connection Error", message: "Oops! Couldn't get salah timings. Please check your connection.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (action) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0 ) {
                self.getPrayerTimingsFromApi()
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
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
