//
//  CovidDataInRealmUpdater.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/22/20.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import RealmSwift



struct CovidDataInRealmUpdater {
    
    static func updateCovidDataInRealm(covidDataInRealm: CovidDataInRealm) {
        print("### about to update covid data in realm")
        if hoursBetweenDates(covidDataInRealm.createTime, Date()) < 6 {
            print("### no need to update data for \(covidDataInRealm.name)")
            return
        }
        var CSC: [String: String] = [:]
        CSC["county"] = covidDataInRealm.county
        CSC["state"] = covidDataInRealm.state
        CSC["country"] = covidDataInRealm.country
        
        AF.request(covidDataAPIBase, parameters: CSC).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json.dictionaryValue.count == 0 { return }
                let realm = try! Realm()
                do {
                    try realm.write {
                        print("### updating data for \(covidDataInRealm.name)")
                        covidDataInRealm.updateData(cases: json["cases"].arrayObject as? [Int], deaths: json["deaths"].arrayObject as? [Int], recovered: json["recovered"].arrayObject as? [Int])
                    }
                } catch {
                    print("Error deleting card \(error)")
                }
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
        
    }
}


func hoursBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {
    //get both times sinces refrenced date and divide by 60 to get minutes
    let newDateHours = newDate.timeIntervalSinceReferenceDate/3600
    let oldDateHours = oldDate.timeIntervalSinceReferenceDate/3600
    //then return the difference
    return CGFloat(newDateHours - oldDateHours)
}
