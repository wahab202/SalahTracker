//
//  SettingsScreenViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 11/30/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsScreenViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedMethod: Int?
    var methods = ["Shia Ithna-Ansari", "University of Islamic Sciences, Karachi", "Islamic Society of North America", "Muslim World League", "Umm Al-Qura University, Makkah", "Egyptian General Authority of Survey", "Institute of Geophysics, University of Tehran", "Gulf Region", "Kuwait", "Qatar", "Majlis Ugama Islam Singapura, Singapore", "Union Organization islamic de France", "Diyanet İşleri Başkanlığı, Turkey", "Spiritual Administration of Muslims of Russia"]
    let defaults = UserDefaults.standard
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var methodinputField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.layer.cornerRadius = 10.0
        locationlabel.text = "Location: " + defaults.string(forKey: "locality")!
        methodinputField.text = methods[defaults.integer(forKey: "method")]
        createPickerView()
        dismissPickerView()
        defaults.setValue(0, forKey: "needsRefresh")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.setValue(0, forKey: "needsRefresh")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return methods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return methods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMethod = row
        methodinputField.text = methods[row]
        defaults.setValue(row, forKey: "method")
        defaults.setValue(1, forKey: "needsRefresh")
    }
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           methodinputField.inputView = pickerView
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       methodinputField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
    
    @IBAction func refreshLocationPressed(_ sender: Any) {
        locationlabel.text = "Location: ..."
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            if currentLoc != nil {
                defaults.set(String(currentLoc.coordinate.latitude),forKey: "latitude")
                defaults.set(String(currentLoc.coordinate.longitude),forKey: "longitude")
                geocode(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude)
            }
        } else {
            let address = Locale.current.localizedString(forRegionCode: Locale.current.regionCode!)
            locationlabel.text = "Location: " + address!
            showLocationAlert()
        }
    }
        
    func handleGeocodeLocation(location: CLPlacemark) {
        defaults.set(String(location.country!),forKey: "country")
        defaults.set(String(location.locality!),forKey: "locality")
        locationlabel.text = "Location: " + location.locality!
        defaults.setValue(1, forKey: "needsRefresh")
    }
    
    func geocode(latitude: Double, longitude: Double) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            if let safePlacemark = placemark {
                self.handleGeocodeLocation(location: safePlacemark[0])
            }
        }
    }
    
    func showLocationAlert() {
        let alert = UIAlertController(title: nil, message: "Please enable location services for more accurate timings.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
        
    @IBAction func resetPrayerPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Prayers", message: "How many prayers do you want to reset?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Reset All", style: UIAlertAction.Style.default, handler: { (action) in
            DatabaseManager.resetAllPrayersFromDatabase()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Reset Today", style: UIAlertAction.Style.default, handler: { (action) in
            DatabaseManager.resetTodayPrayersFromDatabase()
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
}

