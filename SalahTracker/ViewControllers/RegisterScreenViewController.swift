//
//  ViewController.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/22/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterScreenViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var gpsTimer: Timer?
    let maxGpsTry = 5
    var tryCount = 0
    
    let defaults = UserDefaults.standard
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.layer.cornerRadius = 20.0
        startButton.layer.cornerRadius = 7.0
        getCoordinatesFromRegion()
        defaults.set(2,forKey: "method")
        printName()
        nameField.delegate = self
        gpsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
        getLocation()
    }
    
    @IBAction func detectLocationPressed(_ sender: Any) {
        getLocation()
    }
    
    @objc func getLocation() {
        tryCount += 1
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
            if tryCount >= maxGpsTry {
                setLocationTitle(location: defaults.string(forKey: "locality")!)
            }
        }
    }
    
    func setLocationTitle(location: String) {
        locationButton.setTitle("Location: " + location, for: .normal)
        locationButton.isEnabled = false
        locationButton.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
    }
    
    func getCoordinatesFromRegion() {
        let address = Locale.current.localizedString(forRegionCode: Locale.current.regionCode!)
        defaults.set(address, forKey: "locality")
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    return
                }
            self.defaults.set(String(location.coordinate.latitude),forKey: "latitude")
            self.defaults.set(String(location.coordinate.longitude),forKey: "longitude")
        }
    }
    
    func handleGeocodeLocation(location: CLPlacemark) {
        defaults.set(String(location.country!),forKey: "country")
        defaults.set(String(location.locality!),forKey: "locality")
        setLocationTitle(location: location.locality!)
        gpsTimer?.invalidate()
    }
    
    func geocode(latitude: Double, longitude: Double) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            if let safePlacemark = placemark {
                self.handleGeocodeLocation(location: safePlacemark[0])
            }
        }
    }

    @IBAction func touchButtonPressed(_ sender: UIButton) {
        getLocation()
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

