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
}
