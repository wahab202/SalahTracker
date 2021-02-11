//
//  TodayPrayerTableViewCell.swift
//  SalahTracker
//
//  Created by Danial Zahid on 24/07/2020.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import RealmSwift

class TodayPrayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prayedButton: UIButton!
    @IBOutlet weak var qazaButton: UIButton!
    @IBOutlet weak var selectionButtonsView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var todayPrayerLabel: UILabel!
    
    static let identifier = "TodayPrayerTableViewCell"
    let realm = try! Realm()

    override func awakeFromNib() {
        super.awakeFromNib()
        prayedButton.layer.cornerRadius = 5.0
        qazaButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func qazaButtonPressed(_ sender: UIButton) {
        setStatus(status: PrayType.qaza, dueTime: "")
        addPrayerToDatabase(status: PrayType.qaza)
    }
    
    @IBAction func prayedButtonPressed(_ sender: UIButton) {
        setStatus(status: PrayType.prayed, dueTime: "")
        addPrayerToDatabase(status: PrayType.prayed)
    }
    
    func setStatus(status: PrayType, dueTime: String) {
        switch status {
        case .prayed:
            statusLabel.text = "On time"
            statusLabel.textColor = #colorLiteral(red: 0.5052400827, green: 0.7810568213, blue: 0.5157173276, alpha: 1)
            selectionButtonsView.isHidden = true
        case .qaza:
            statusLabel.text = "Delayed"
            statusLabel.textColor = #colorLiteral(red: 1, green: 0.4590665102, blue: 0.4428348541, alpha: 1)
            selectionButtonsView.isHidden = true
        case .notYetDue:
            statusLabel.text = "Starts at " + dueTime
            statusLabel.textColor = UIColor(named: "general")
            selectionButtonsView.isHidden = true
        case .noRecord:
            statusLabel.text = ""
            selectionButtonsView.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func addPrayerToDatabase(status:PrayType){
        let prayer = Prayer()
        prayer.id = todayPrayerLabel.text ?? "Nil"
        prayer.date = Date()
        prayer.status = status.rawValue
        try! realm.write {
            realm.add(prayer)
        }
    }
    
    func setupCell(index: Int, prayerNamesArray: [String], prayerTimes: [Date]!, errorStatus: Int, status: PrayType, dateFormatter: DateFormatter) {
        var mutableStatus = status
        let currentTime = Date()
        self.todayPrayerLabel.text = prayerNamesArray[index]
        if prayerTimes == nil {
            self.statusLabel.text = errorStatus == 0 ? "Loading..." : ""
            self.statusLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self.selectionButtonsView.isHidden = true
            return
        }
        if errorStatus == 0 {
            if mutableStatus == PrayType.noRecord {
                if currentTime < prayerTimes[index] {
                    mutableStatus = PrayType.notYetDue
                }
            }
        }
        switch mutableStatus {
        case .prayed:
            self.setStatus(status: PrayType.prayed, dueTime: "")
        case .qaza:
            self.setStatus(status: PrayType.qaza, dueTime: "")
        case .noRecord:
            self.setStatus(status: PrayType.noRecord, dueTime: "")
        case .notYetDue:
            self.setStatus(status: PrayType.notYetDue, dueTime: errorStatus == 0 ? dateFormatter.string(from: prayerTimes[index]) : "")
        }
    }
}
