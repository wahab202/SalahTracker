//
//  NetworkManager.swift
//  SalahTracker
//
//  Created by Abdul Wahab on 7/29/20.
//  Copyright © 2020 Abdul Wahab. All rights reserved.
//

import Foundation
import Alamofire
import AFNetworking
import SwiftyJSON

enum RequestMethod: Int {
    case alamofire = 0
    case afnetworking = 1
}

class NetworkManager {
    
    static var apiLink = "http://api.aladhan.com/v1/calendar?latitude=33.684422&longitude=73.047882&method=2&month="
    
    static func getPrayerTimingsFromAPI(method:RequestMethod, completionHandler: @escaping (PrayerTiming?,Int?) -> ()) {
        let date = Date()
        let calendar = Calendar.current
        let mutatedLink = apiLink + String(calendar.component(.month, from: date)) + "&year=" + String(calendar.component(.year, from: date))
        if method == RequestMethod.alamofire {
            AF.request(mutatedLink)
                .responseJSON { response in
                    switch response.result {
                    case .success( _):
                        do {
                            let json = try JSON(data: response.data!)
                            let todayData = json["data"][0]["timings"].rawString()
                            let todayJsonData = todayData?.data(using: .utf8)!
                            let timings = try! JSONDecoder().decode(PrayerTiming.self, from: todayJsonData!)
                            completionHandler(timings as PrayerTiming,0)
                        } catch {
                            completionHandler(PrayerTiming(),1)
                            print(error)
                        }
                    case .failure(_):
                        completionHandler(PrayerTiming(),1)
                    }
                    if response.data != nil {
                        
                    }
            }
        }
    }
}
