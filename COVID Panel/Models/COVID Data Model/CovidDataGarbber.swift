//
//  CovidDataManager.swift
//  Solid News
//
//  Created by Fan Zhang on 11/18/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import GoogleMaps

let covidDataAPIBase: String = ""

struct CovidDataGarbber {
    
    @Binding var covidData: CovidDataModel?
    
    @AppStorage("defaultLang") var defaultLang: String?
    
    func updateView(addr_string: String, mapGoTo: @escaping (GMSCameraPosition) -> Void) {
        print("### geocoding from address string")
        let geocoder: GeoCoder = GeoCoder(addr_string: addr_string)
        geocoder.geocodingAndUpdate(getData: requestDataFromCSC, mapGoTo: mapGoTo)
    }
    
    func updateViewFromCoordinates(lat: Double, lon: Double, mapGoTo: @escaping (GMSCameraPosition) -> Void) {
        print("### geocoding from coordinates")
        let geocoder: ReversedGeoCOder = ReversedGeoCOder(lat: lat, lon: lon)
        geocoder.reverseGeocodingAndUpdate(getData: requestDataFromCSC, mapGoTo: mapGoTo)
    }
    
    func requestDataFromCSC(CSC: [String: String]) {
        
        print("### requesting covid data from CSC")
        AF.request(covidDataAPIBase, parameters: CSC).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json.dictionaryValue.count == 0 { return }
                SingleLineTranslater.translateAndDoCallback(content: json["name"].stringValue, lang: defaultLang!, callback: { translatedName in
                    var county = CSC["county"]!
                    var state = CSC["state"]!
                    let country = CSC["country"]
                    if json["name"].stringValue == CSC["country"] {
                        state = ""
                        county = ""
                    } else if json["name"].stringValue == CSC["state"] {
                        county = ""
                    }
                    let new_covidData = CovidDataModel(name: translatedName,county: county,state: state,country: country,cases: json["cases"].arrayObject as? [Int],deaths: json["deaths"].arrayObject as? [Int],recovered: json["recovered"].arrayObject as? [Int])
                    covidData = new_covidData
                    
                })
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
        
    }
    
}

