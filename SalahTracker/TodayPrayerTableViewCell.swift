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
        setStatusToQaza()
        addPrayerToDatabase(status: "Qaza")
    }
    
    @IBAction func prayedButtonPressed(_ sender: UIButton) {
        setStatusToPrayed()
        addPrayerToDatabase(status: "Prayed")
    }
    
    func setStatus(status: PrayType) {
        switch status {
        case .prayed:
            print("")
        case .qaza:
            print("")
        }
    }
    
    func setStatusToQaza() {
        statusLabel.text = "Prayer was Qaza"
        statusLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        selectionButtonsView.isHidden = true
    }
    
    func setStatusToPrayed() {
        statusLabel.text = "Prayed in time"
        statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        selectionButtonsView.isHidden = true
    }
    
    func setStatusToDueInTime(time: String) {
        statusLabel.text = "Due at " + time
        statusLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        selectionButtonsView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func addPrayerToDatabase(status:String){
        let prayer = Prayer()
        prayer.id = todayPrayerLabel.text ?? "Nil"
        prayer.date = Date()
        prayer.status = status
        try! realm.write {
            realm.add(prayer)
        }
    }

}
