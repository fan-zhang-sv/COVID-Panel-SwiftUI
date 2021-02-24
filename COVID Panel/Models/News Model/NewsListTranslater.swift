//
//  TranslateManager.swift
//  Solid News
//
//  Created by Fan Zhang on 11/13/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

let translaterBase: String = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to="

let Translaterheaders: HTTPHeaders = [
    "content-type": "application/json; charset=UTF-8",
    "Ocp-Apim-Subscription-Key": "",
    "Ocp-Apim-Subscription-Region": "westus2"
]

struct SingleLineTranslater {
    
    static func translateAndDoCallback(content: String, lang: String, callback: @escaping (String) -> Void) {
        let requestBody: [[String: String]] = [
            ["Text": content]
        ]
        var request = URLRequest(url: try! (translaterBase+lang).asURL())
        request.httpMethod = "POST"
        request.headers = Translaterheaders
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody)
        
        AF.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let array = JSON(value)
                let translatedContent = array.arrayValue[0]["translations"].arrayValue[0]["text"].stringValue
                callback(translatedContent)
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }
    
}


struct NewsListTranslater {
    
    @Binding var newsList: [NewsModel]?
    
    @AppStorage("defaultLang") var defaultLang: String?

    func swapNewsLanguage(news: NewsModel) -> NewsModel {
        return NewsModel(
            name: news.bufferedName,
            url: news.url,
            providerName: news.bufferedProviderName,
            datePublished: news.datePublished,
            translatedLang: news.translatedLang,
            bufferedName: news.name,
            bufferedProviderName: news.providerName
            )
    }
    
    func archiveDataAndTranslate() {
        print("### Translating data")
        
        guard let _ = newsList else { return }
        
        for (idx, news) in newsList!.enumerated() {
            if news.translatedLang == defaultLang {
                newsList![idx] = swapNewsLanguage(news: news)
            } else {
                translateNews(idx: idx, news: news)
            }
        }
    }
    
    func translateNews(idx: Int, news: NewsModel) {
        
        let requestBody: [[String: String]] = [
            ["Text": news.providerName!],
            ["Text": news.name!]
        ]
        
        var request = URLRequest(url: try! (translaterBase+defaultLang!).asURL())
        request.httpMethod = "POST"
        request.headers = Translaterheaders
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody)
        
        AF.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let array = JSON(value)
                var buffer: [String?] = []
                array.arrayValue.forEach { (result) in
                    buffer.append(result["translations"].array?[0]["text"].string)
                }
                
                let new_news = NewsModel(
                    name: buffer[1],
                    url: news.url,
                    providerName: buffer[0],
                    datePublished: news.datePublished,
                    translatedLang: defaultLang,
                    bufferedName: news.name,
                    bufferedProviderName: news.providerName
                    )
                
                newsList![idx] = new_news
                
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }
    
    
    func untranslate() {
        print("### Untranslating data")
        
        guard let _ = newsList else { return }
        
        for (idx, news) in newsList!.enumerated() {
            newsList![idx] = swapNewsLanguage(news: news)
        }
    }
    
}
