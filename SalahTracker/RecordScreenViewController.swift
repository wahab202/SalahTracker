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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier) as! RecordTableViewCell
        let prayers = getPrayersFromDatabase(ofDate: Date())
        let prayed = prayers.filter { $0.status == PrayType.prayed.rawValue }
        let qazad = prayers.filter { $0.status == PrayType.qaza.rawValue }
        cell.recordDateLabel.text = dateFormatter.string(from: Date())
        cell.prayerDetailsLabel.text = String(qazad.count) + " Qaza, " + String(prayed.count) + " Prayed"
        return cell
    }
    
    func getPrayersFromDatabase(ofDate date:Date) -> [Prayer] {
        let prayerList = realm.objects(Prayer.self)
        let prayers = prayerList.filter { Calendar.current.isDate($0.date, inSameDayAs: date)}
        return Array(prayers)
    }
    
    
    
    

}
