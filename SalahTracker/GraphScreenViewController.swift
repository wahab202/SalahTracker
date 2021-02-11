//
//  GraphScreenViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 2/11/21.
//  Copyright © 2021 Abdul Wahab. All rights reserved.
//

import UIKit
import PieCharts

class GraphScreenViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChart!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var prayedCountLabel: UILabel!
    @IBOutlet weak var delayedCountLabel: UILabel!
    @IBOutlet weak var missedCountLabel: UILabel!
    
    public var prayed = 0
    public var missed = 0
    public var delayed = 0
    public var daysOfRecord = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if daysOfRecord == 1 {
            dayCountLabel.text = "Today"
        } else {
            dayCountLabel.text = "Last \(daysOfRecord) days."
        }
        prayedCountLabel.text = String(prayed)
        delayedCountLabel.text = String(delayed)
        missedCountLabel.text = String(missed)
        pieChartView.isUserInteractionEnabled = false
        pieChartView.models = [
            PieSliceModel(value: Double(prayed), color: UIColor(named: "greenButton")!),
            PieSliceModel(value: Double(delayed), color: UIColor(named: "orangeBg")!),
            PieSliceModel(value: Double(missed), color: UIColor(named: "redButton")!)
        ]
    }
}
