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
    
    static let identifier = "RecordTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(index: Int, prayerList: [Prayer], dateFormatter: DateFormatter, dateOfRecord: Date) {
        let prayed = prayerList.filter { $0.status == PrayType.prayed.rawValue }
        let qazad = prayerList.filter { $0.status == PrayType.qaza.rawValue }
        if prayed.count == 0, qazad.count == 0 {
            self.prayerDetailsLabel.text = "No Record Found."
        } else {
            self.prayerDetailsLabel.text = String(qazad.count) + " Qaza, " + String(prayed.count) + " Prayed"
        }
        if Calendar.current.isDate(dateOfRecord, inSameDayAs: Date()) {
            self.recordDateLabel.text = "Today"
        } else {
            self.recordDateLabel.text = dateFormatter.string(from: dateOfRecord)
        }
    }
}
