//
//  MapDotModel.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/23/20.
//

import SwiftUI
import RealmSwift

class MapDotInRealm: Object {
    
    @objc dynamic var createTime: Date = Date()
    
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    
    @objc dynamic var total_cases: Int = 0
    @objc dynamic var today_cases: Int = 0
    @objc dynamic var total_deaths: Int = 0
    @objc dynamic var today_deaths: Int = 0
    
    convenience init(lat: Double, lon: Double, total_cases: Int, today_cases: Int, total_deaths: Int, today_deaths: Int) {
        self.init()
        self.lat = lat
        self.lon = lon
        self.total_cases = total_cases
        self.today_cases = today_cases
        self.total_deaths = total_deaths
        self.today_deaths = today_deaths
    }
    
}
