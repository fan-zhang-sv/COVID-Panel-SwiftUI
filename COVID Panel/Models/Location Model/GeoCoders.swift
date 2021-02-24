//
//  GeoCodingManager.swift
//  Solid News
//
//  Created by Fan Zhang on 11/18/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import GoogleMaps

let geoCodingBase: String = "https://maps.googleapis.com/maps/api/geocode/json"

struct GeoCoder {

    let addr_string: String
    var params: [String: String] {
        [
            "address": addr_string,
            "key": ""
        ]
    }
    
    func geocodingAndUpdate(getData: @escaping ([String : String]) -> Void, mapGoTo: @escaping (GMSCameraPosition) -> Void) {
        
        print("### Geocoding")
        AF.request(geoCodingBase, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var CSC = [
                    "county": "",
                    "state": "",
                    "country": ""
                ]
                
                if json["results"].arrayValue.count == 0 { return }
                
                let address_components = json["results"].array?[0]["address_components"].arrayValue
                address_components?.forEach { (component) in
                    if component["types"].arrayValue[0] == "administrative_area_level_2" {
                        CSC["county"] = component["long_name"].stringValue
                        CSC["county"] = CSC["county"]!.replacingOccurrences(of: "County", with: "")
                        CSC["county"] = CSC["county"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if component["types"].arrayValue[0] == "administrative_area_level_1" {
                        CSC["state"] = component["long_name"].stringValue
                        CSC["state"] = CSC["state"]!.replacingOccurrences(of: "Province", with: "")
                        CSC["state"] = CSC["state"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if component["types"].arrayValue[0] == "country" {
                        CSC["country"] = component["long_name"].stringValue
                    }
                }
                
                print(CSC)
                getData(CSC)
                
                guard let lat = json["results"].array?[0]["geometry"]["location"]["lat"].double else { return }
                guard let lon = json["results"].array?[0]["geometry"]["location"]["lng"].double else { return }
                
                mapGoTo(GMSCameraPosition.camera(withLatitude: UIDevice.current.userInterfaceIdiom == .pad ? lat : (lat - 0.2), longitude: lon, zoom: 10.0))
                
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }
}


struct ReversedGeoCOder {
    
    let lat: Double
    let lon: Double
    
    var params: [String: String] {
        [
            "latlng": String(lat)+","+String(lon),
            "key": "AIzaSyA71lGqDushBuMVbwmCtfK2lw3wEEjtnQI"
        ]
    }
    
    func reverseGeocodingAndUpdate(getData: @escaping ([String : String]) -> Void, mapGoTo: @escaping (GMSCameraPosition) -> Void) {
        
        print("### Geocoding")
        AF.request(geoCodingBase, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var CSC = [
                    "county": "",
                    "state": "",
                    "country": ""
                ]
                
                if json["results"].arrayValue.count == 0 { return }
                
                let address_components = json["results"].array?[0]["address_components"].arrayValue
                address_components?.forEach { (component) in
                    if component["types"].arrayValue[0] == "administrative_area_level_2" {
                        CSC["county"] = component["long_name"].stringValue
                        CSC["county"] = CSC["county"]!.replacingOccurrences(of: "County", with: "")
                        CSC["county"] = CSC["county"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if component["types"].arrayValue[0] == "administrative_area_level_1" {
                        CSC["state"] = component["long_name"].stringValue
                        CSC["state"] = CSC["state"]!.replacingOccurrences(of: "Province", with: "")
                        CSC["state"] = CSC["state"]!.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if component["types"].arrayValue[0] == "country" {
                        CSC["country"] = component["long_name"].stringValue
                    }
                }
                
                print(CSC)
                getData(CSC)
                
                guard let lat = json["results"].array?[0]["geometry"]["location"]["lat"].double else { return }
                guard let lon = json["results"].array?[0]["geometry"]["location"]["lng"].double else { return }
                mapGoTo(GMSCameraPosition.camera(withLatitude: UIDevice.current.userInterfaceIdiom == .pad ? lat : (lat - 0.2), longitude: lon, zoom: 10.0))
                
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
        
    }
    
    
}


