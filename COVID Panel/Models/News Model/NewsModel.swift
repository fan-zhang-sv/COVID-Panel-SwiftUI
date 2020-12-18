//
//  NewsModel.swift
//  Solid News
//
//  Created by Fan Zhang on 11/10/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import Foundation
import RealmSwift

struct NewsModel: Identifiable {
    
    let id = UUID()
    
    let name: String?
    let url: String?
    let providerName: String?
    let datePublished: String?
    
    var translatedLang: String?
    var bufferedName: String?
    var bufferedProviderName: String?
    
    init(name: String?, url: String?, providerName: String?, datePublished: String?, translatedLang: String? = nil, bufferedName: String? = nil, bufferedProviderName: String? = nil) {
        self.name = name
        self.url = url
        self.providerName = providerName
        self.datePublished = datePublished
        self.translatedLang = translatedLang
        self.bufferedName = bufferedName
        self.bufferedProviderName = bufferedProviderName
    }
    
    static func defaultNews() -> NewsModel {
        return NewsModel(
            name: "FDA gives emergency authorization to drug that can keep COVID-19 patients out of the hospital",
            url: "https://www.usatoday.com/story/news/health/2020/11/09/fda-issues-emergency-use-authorization-covid-19-drug/6229291002/",
            providerName: "USA Today",
            datePublished: "2020-11-10T01:20:00.0000000Z")
    }
    
}
