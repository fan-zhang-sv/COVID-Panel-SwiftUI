//
//  MapDotUpdater.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/23/20.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import RealmSwift

let mapDotUpdaterBase = mapDotsUrl

struct MapDotUpdater {
    
    static func updateCovidDataInRealm() {
        
        print("### about to update map dots in realm")
        let realm = try! Realm()
        let results = realm.objects(MapDotInRealm.self)
        
        if results.count > 0 &&  hoursBetweenDates(results[0].createTime, Date()) < 6 {
            print("### no need to update map dots")
            return
        }
        
        print("### updating map dots")
        AF.request(mapDotUpdaterBase).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json.arrayValue.count == 0 { return }

                do {
                    try realm.write {
                        realm.delete(results)
                        json.arrayValue.forEach { datapoint in
                            let mapDot = MapDotInRealm(lat: datapoint["lat"].doubleValue, lon: datapoint["lon"].doubleValue, total_cases: datapoint["total_cases"].intValue, today_cases: datapoint["new_cases"].intValue, total_deaths: datapoint["total_deaths"].intValue, today_deaths: datapoint["new_deaths"].intValue)
                            realm.add(mapDot)
                        }
                    }
                } catch {
                    print("Error updating map dots \(error)")
                }

                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }
    
}
