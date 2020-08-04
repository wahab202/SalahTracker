//
//  ViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/22/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit

class RegisterScreenViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        printName()
        nameField.delegate = self
    }

    @IBAction func touchButtonPressed(_ sender: UIButton) {
        defaults.set(nameField.text,forKey: "Name")
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func printName(){
        print(defaults.string(forKey: "Name") ?? "Empty")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
}

