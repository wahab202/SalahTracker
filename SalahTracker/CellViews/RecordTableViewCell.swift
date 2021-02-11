//
//  RecordTableViewCell.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/28/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recordDateLabel: UILabel!
    @IBOutlet weak var prayerDetailsLabel: UILabel!
    
    public var prayedCount = 0
    public var missedCount = 0
    public var delayedCount = 0
    public var recordFound = false
    
    static let identifier = "RecordTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(index: Int, prayerList: [Prayer], dateFormatter: DateFormatter, dateOfRecord: Date) {
        prayedCount = 0
        missedCount = 0
        delayedCount = 0
        recordFound = false
        let prayed = prayerList.filter { $0.status == PrayType.prayed.rawValue }
        let qazad = prayerList.filter { $0.status == PrayType.qaza.rawValue }
        if prayed.count == 0, qazad.count == 0 {
            self.prayerDetailsLabel.text = "No history found."
        } else {
            self.prayerDetailsLabel.text = String(qazad.count) + " delayed, " + String(prayed.count) + " on time."
            prayedCount = prayedCount + prayed.count
            delayedCount = delayedCount + qazad.count
            missedCount = missedCount + (5 - prayed.count - qazad.count)
            recordFound = true
        }
        if Calendar.current.isDate(dateOfRecord, inSameDayAs: Date()) {
            self.recordDateLabel.text = "Today"
            missedCount = missedCount - (5 - prayed.count - qazad.count)
        } else {
            self.recordDateLabel.text = dateFormatter.string(from: dateOfRecord)
        }
        if !recordFound {
            self.prayerDetailsLabel.text = ""
            self.recordDateLabel.text = ""
        }
    }
}
