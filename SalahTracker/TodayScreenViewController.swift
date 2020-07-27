//
//  TodayScreenViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/24/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import RealmSwift

class TodayScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let prayerNamesArray = ["Fajr","Dhuhr","Asr","Maghrib","Isha"]
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func resetPrayers(_ sender: UIButton) {
        try! realm.write {
          realm.deleteAll()
        }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = getPrayerStatusFromDatabase(id: prayerNamesArray[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayPrayerTableViewCell.identifier) as! TodayPrayerTableViewCell
        cell.todayPrayerLabel.text = prayerNamesArray[indexPath.row]
        if status == "Qaza" {
            cell.setStatusToQaza()
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
