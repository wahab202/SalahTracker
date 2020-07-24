//
//  TodayPrayerTableViewCell.swift
//  SalahTracker
//
//  Created by Danial Zahid on 24/07/2020.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit

class TodayPrayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionButtonsView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var todayPrayerLabel: UILabel!
    static let identifier = "TodayPrayerTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func qazaButtonPressed(_ sender: UIButton) {
        statusLabel.text = "Prayer was Qaza"
        statusLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        selectionButtonsView.isHidden = true
    }
    
    @IBAction func prayedButtonPressed(_ sender: UIButton) {
        statusLabel.text = "Prayed in time"
        statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        selectionButtonsView.isHidden = true

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
