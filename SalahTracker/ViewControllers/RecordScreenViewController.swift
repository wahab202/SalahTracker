//
//  RecordScreenViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/24/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import RealmSwift

class RecordScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    let realm = try! Realm()
    let dateFormatter = DateFormatter()
    let now = Calendar.current.dateComponents(in: .current, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier) as! RecordTableViewCell
        let dateOfRecord = Calendar.current.date(from: DateComponents(year: now.year, month: now.month, day: now.day! - indexPath.row))!
        let prayerList = getPrayersFromDatabase(ofDate: dateOfRecord)
        let prayed = prayerList.filter { $0.status == PrayType.prayed.rawValue }
        let qazad = prayerList.filter { $0.status == PrayType.qaza.rawValue }
        if prayed.count == 0, qazad.count == 0 {
            cell.prayerDetailsLabel.text = "No Record Found."
        } else {
            cell.prayerDetailsLabel.text = String(qazad.count) + " Qaza, " + String(prayed.count) + " Prayed"
        }
        if Calendar.current.isDate(dateOfRecord, inSameDayAs: Date()) {
            cell.recordDateLabel.text = "Today"
        } else {
            cell.recordDateLabel.text = dateFormatter.string(from: dateOfRecord)
        }
        return cell
    }
    
    func getPrayersFromDatabase(ofDate date:Date) -> [Prayer] {
        let prayerList = realm.objects(Prayer.self)
        let prayers = prayerList.filter { Calendar.current.isDate($0.date, inSameDayAs: date)}
        return Array(prayers)
    }
}
