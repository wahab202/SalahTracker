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
        let prayerList = DatabaseManager.getPrayersFromDatabase(ofDate: dateOfRecord)
        cell.setupCell(index: indexPath.row, prayerList: prayerList, dateFormatter: dateFormatter, dateOfRecord: dateOfRecord)
        return cell
    }
}
