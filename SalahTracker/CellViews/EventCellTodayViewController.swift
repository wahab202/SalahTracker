//
//  EventCellTodayViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/29/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit

class EventCellTodayViewController: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var backgroudView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setColor(label:String){
        if label == "Sunrise ☀️" {
            self.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        } else {
            self.backgroundColor = #colorLiteral(red: 0.08566582364, green: 0.1435127101, blue: 0.342262849, alpha: 1)
        }
    }
    
    func setupCell(prayerTimes: [Date]!, prayerNamesArray: [String], errorStatus: Int, dateFormatter: DateFormatter, index: Int) {
        if prayerTimes != nil {
            self.timeLabel.text = prayerNamesArray[index]
            self.iconLabel.text = errorStatus == 0 ? dateFormatter.string(from: prayerTimes[index]) : ""
            self.setColor(label: prayerNamesArray[index])
        }
    }
}
