//
//  AppDelegate.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/22/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let _ = UserDefaults.standard.value(forKey: "Name") as? String {
            let tabBarController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.window?.rootViewController = tabBarController
        }
        else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewUserViewController")
            self.window?.rootViewController = vc
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }

    
    


}

