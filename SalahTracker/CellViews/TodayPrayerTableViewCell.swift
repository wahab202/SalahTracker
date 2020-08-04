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
            statusLabel.text = "Prayed in time"
            statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            selectionButtonsView.isHidden = true
        case .qaza:
            statusLabel.text = "Prayer was Qaza"
            statusLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            selectionButtonsView.isHidden = true
        case .notYetDue:
            statusLabel.text = "Starts at " + dueTime
            statusLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
}
