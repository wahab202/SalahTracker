//
//  ViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/22/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        printName()
    }

    let defaults = UserDefaults.standard
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func touchStart(_ sender: UIButton) {
        defaults.set(nameField.text,forKey: "Name")
    }
    
    func printName(){
        print(defaults.string(forKey: "Name") ?? "Empty")
    }
    
}

