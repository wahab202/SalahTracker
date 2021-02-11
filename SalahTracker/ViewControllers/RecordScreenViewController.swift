//
//  RecordScreenViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/24/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import RealmSwift

enum ViewType {
    case prayed
    case delayed
    case missed
}

class RecordScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var showGraphButton: UIButton!
    @IBOutlet weak var viewTypeButton: UIButton!
    
    let realm = try! Realm()
    let dateFormatter = DateFormatter()
    let now = Calendar.current.dateComponents(in: .current, from: Date())
    
    var prayed = 0
    var missed = 0
    var delayed = 0
    var daysOfRecord = 0
    var viewType = ViewType.prayed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGraphButton.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showGraphButton.isHidden = true
        reloadTableViewData()
    }
    
    private func reloadTableViewData() {
        tableview.reloadData()
        prayed = 0
        missed = 0
        delayed = 0
        daysOfRecord = 0
    }
    
    @IBAction func showGraphTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "moveToGraph", sender: nil)
    }
    
    @IBAction func viewTypeTapped(_ sender: UIButton) {
        let type = sender.titleLabel?.text
        if type == "Show missed" {
            viewType = ViewType.missed
            viewTypeButton.setTitle("Show prayed", for: .normal)
            reloadTableViewData()
        } else if type == "Show delayed" {
            viewType = ViewType.delayed
            viewTypeButton.setTitle("Show missed", for: .normal)
            reloadTableViewData()
        } else if type == "Show prayed" {
            viewType = ViewType.prayed
            viewTypeButton.setTitle("Show delayed", for: .normal)
            reloadTableViewData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToGraph" {
            let vc = segue.destination as! GraphScreenViewController
            vc.delayed = delayed
            vc.prayed = prayed
            vc.missed = missed
            vc.daysOfRecord = daysOfRecord
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            prayed = 0
            missed = 0
            delayed = 0
            daysOfRecord = 0
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier) as! RecordTableViewCell
        let dateOfRecord = Calendar.current.date(from: DateComponents(year: now.year, month: now.month, day: now.day! - indexPath.row))!
        let prayerList = DatabaseManager.getPrayersFromDatabase(ofDate: dateOfRecord)
        cell.setupCell(index: indexPath.row, prayerList: prayerList, dateFormatter: dateFormatter, dateOfRecord: dateOfRecord, viewType: viewType)
        if cell.recordFound {
            prayed = prayed + cell.prayedCount
            missed = missed + cell.missedCount
            delayed = delayed + cell.delayedCount
            showGraphButton.isHidden = false
            daysOfRecord += 1
        }
        if indexPath.row == 0 && !cell.recordFound {
            cell.recordDateLabel.text = "You have no prayer records yet."
        }
        return cell
    }
}
