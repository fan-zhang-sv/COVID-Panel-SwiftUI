//
//  CovidDataModel.swift
//  Solid News
//
//  Created by Fan Zhang on 11/18/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import Foundation
import RealmSwift

struct CovidDataModel {
    
    static let dataLength = 91
    
    let name: String?
    let county: String?
    let state: String?
    let country: String?
    
    let cases: [Int]?
    let deaths: [Int]?
    let recovered: [Int]?
    
    
    init(name: String?, county: String?, state: String?, country: String?, cases: [Int]?, deaths: [Int]?, recovered: [Int]?) {
        self.name = name
        self.county = county
        self.state = state
        self.country = country
        self.cases = cases
        self.deaths = deaths
        self.recovered = recovered
    }
    
    init(covidDataInRealm: CovidDataInRealm) {
        self.name = covidDataInRealm.name
        self.county = covidDataInRealm.county
        self.state = covidDataInRealm.state
        self.country = covidDataInRealm.country
        if covidDataInRealm.cases.count == CovidDataModel.dataLength {
            var temp: [Int] = []
            covidDataInRealm.cases.forEach { num in
                temp.append(num)
            }
            self.cases = temp
        } else {
            self.cases = nil
        }
        if covidDataInRealm.deaths.count == CovidDataModel.dataLength {
            var temp: [Int] = []
            covidDataInRealm.deaths.forEach { num in
                temp.append(num)
            }
            self.deaths = temp
        } else {
            self.deaths = nil
        }
        if covidDataInRealm.recovered.count == CovidDataModel.dataLength {
            var temp: [Int] = []
            covidDataInRealm.recovered.forEach { num in
                temp.append(num)
            }
            self.recovered = temp
        } else {
            self.recovered = nil
        }
    }
    
    static func defaultCovidData() -> CovidDataModel {
        return CovidDataModel(
            name: "Santa Clara",
            county: "Santa Clara",
            state: "California",
            country: "United States",
            cases: (0..<dataLength).map({ num in num * num}),
            deaths: (0..<dataLength).map({ num in num * num}),
            recovered: (0..<dataLength).map({ num in num * num})
        )
    }

}


class CovidDataInRealm: Object {
    
    @objc dynamic var createTime: Date = Date()
    
    @objc dynamic var name: String = ""
    @objc dynamic var order: Int = 0
    @objc dynamic var county: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var country: String = ""
    
    let cases = List<Int>()
    let deaths = List<Int>()
    let recovered = List<Int>()
    
    convenience init(name: String, order: Int, county: String, state: String, country: String, cases: [Int]?, deaths: [Int]?, recovered: [Int]?) {
        self.init()
        self.name = name
        self.order = order
        self.county = county
        self.state = state
        self.country = country
        if let safe_cases = cases {
            for num in safe_cases {
                self.cases.append(num)
            }
        }
        if let safe_deaths = deaths {
            for num in safe_deaths {
                self.deaths.append(num)
            }
        }
        if let safe_recovered = recovered {
            for num in safe_recovered {
                self.recovered.append(num)
            }
        }
    }
    
    convenience init(covidDataModel: CovidDataModel, order: Int) {
        self.init()
        self.name = covidDataModel.name ?? ""
        self.order = order
        self.county = covidDataModel.county ?? ""
        self.state = covidDataModel.state ?? ""
        self.country = covidDataModel.country ?? ""
        if let safe_cases = covidDataModel.cases {
            for num in safe_cases {
                self.cases.append(num)
            }
        }
        if let safe_deaths = covidDataModel.deaths {
            for num in safe_deaths {
                self.deaths.append(num)
            }
        }
        if let safe_recovered = covidDataModel.recovered {
            for num in safe_recovered {
                self.recovered.append(num)
            }
        }
    }
    
    func updateData(cases: [Int]?, deaths: [Int]?, recovered: [Int]?) {
        self.createTime = Date()
        self.cases.removeAll()
        self.deaths.removeAll()
        self.recovered.removeAll()
        if let safe_cases = cases {
            for num in safe_cases {
                self.cases.append(num)
            }
        }
        if let safe_deaths = deaths {
            for num in safe_deaths {
                self.deaths.append(num)
            }
        }
        if let safe_recovered = recovered {
            for num in safe_recovered {
                self.recovered.append(num)
            }
        }
    }
    
    static func addDataToRealm(name: String, order: Int, county: String, state: String, country: String) {
        let data = CovidDataInRealm(name: name, order: order, county: county, state: state, country: country, cases: Array(0..<CovidDataModel.dataLength).map({ num in num * num}), deaths: Array(0..<CovidDataModel.dataLength).map({ num in num * num}), recovered: Array(0..<CovidDataModel.dataLength).map({ num in num * num}))
        data.createTime = Date(timeIntervalSinceReferenceDate: 0)
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error adding data to realm \(error)")
        }
    }

}



extension CovidDataModel {
    
    func getTodayCases(offset: Int = 1) -> Int {
        return self.cases![CovidDataModel.dataLength-offset]
    }
    
    func getTodayDeaths(offset: Int = 1) -> Int {
        return self.deaths![CovidDataModel.dataLength-offset]
    }
    
    func hasRecoveredData() -> Bool {
        return self.recovered != nil
    }
    
    func getTodayRecovered(offset: Int = 1) -> Int? {
        return self.recovered?[CovidDataModel.dataLength-offset]
    }
    
    func getTodayNewCases(offset: Int = 1) -> Int {
        return self.getTodayCases(offset: offset) - self.getTodayCases(offset: offset+1)
    }
    
    func getTodayNewDeath(offset: Int = 1) -> Int {
        return self.getTodayDeaths(offset: offset) - self.getTodayDeaths(offset: offset+1)
    }
    
    func getFatality(offset: Int = 1) -> String {
        let fatality = Float (self.getTodayDeaths(offset: offset)) / Float (self.getTodayCases(offset: offset)) * Float (100)
        return String(format: "%.2f", fatality) + "%"
    }
    
    func getDailyGrowthRate(offset: Int = 1) -> String {
        let dailyGrowthRate = Float (self.getTodayNewCases(offset: offset)) / Float(self.getTodayNewCases(offset: offset+1))  * Float (100)
        return String(format: "%.2f", dailyGrowthRate) + "%"
    }
    
    func get14DaysGrowthRate(offset: Int = 1) -> String {
        if CovidDataModel.dataLength-offset-26 > 0 {
            let growth = self.cases![CovidDataModel.dataLength-(offset+13)...CovidDataModel.dataLength-offset].reduce(0, +)
            let base = self.cases![CovidDataModel.dataLength-(offset+28)...CovidDataModel.dataLength-(offset+15)].reduce(0, +)
            let fourteenDaysGrowthRate = Float (growth) / Float(base)  * Float (100)
            return String(format: "%.2f", fourteenDaysGrowthRate) + "%"
        }
        return "N/A"
    }
    
    func getQueryForRealm() -> String {
        let countyQuery = "county = '\(self.county ?? "")'"
        let stateQuery = "state = '\(self.state ?? "")'"
        let countryQuery = "country = '\(self.country ?? "")'"
        return [countyQuery, stateQuery, countryQuery].joined(separator: " AND ")
    }
    
}
