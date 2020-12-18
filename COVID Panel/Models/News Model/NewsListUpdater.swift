//
//  NewsManager.swift
//  Solid News
//
//  Created by Fan Zhang on 11/9/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct NewsListUpdater {
    
    @Binding var newsList: [NewsModel]?
    
    var country: String
    
    let base: String = "https://my-news-app.cognitiveservices.azure.com/bing/v7.0/news/search"
    let headers: HTTPHeaders = [
        "content-type": "application/json",
        "Ocp-Apim-Subscription-Key": newsKey
    ]
    
    var paramTemplate: [String: String] {
        [
            "mkt": Languages.countryToMkt[country]!,
            "count": "4",
            "originalImg": "true",
            "freshness": "Week",
            "q": Languages.covidName[Languages.countryToLang[country]!]!
        ]
    }
    
    func updateViews(searchTopic: String? = nil, translate: @escaping (String, String, @escaping (String) -> Void) -> Void = {_,_,_ in}) {
        if let safe_searchTopic = searchTopic {
            translate(safe_searchTopic, Languages.countryToLang[country]!, self.requestNews)
            return
        }
    }
    
    func requestNews(searchTopic:  String) {
        
        var parameters = paramTemplate
        if country == "China" {
            parameters.removeValue(forKey: "freshness")
        }

        parameters["q"] = Languages.covidName[Languages.countryToLang[country]!]! + "+" + searchTopic
        
        newsList = []
        
        print("### Requested from Bing News")
        AF.request(base, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                json["value"].arrayValue.forEach { (news) in
                    let thisNews = NewsModel(name: news["name"].string, url: news["url"].string, providerName: news["provider"].array?[0]["name"].string, datePublished: news["datePublished"].string)
                    newsList?.append(thisNews)
                }
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }
    
}

