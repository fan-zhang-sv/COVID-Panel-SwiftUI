//
//  Countries.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/20/20.
//

import Foundation

struct Languages {
    
    static let lang = [
        "en",
//        "es",
        "zh-Hans",
        "zh-Hant",
        "ja",
        "ko"
//        "de",
//        "fr"
    ]
    
    static let countryToLang = [
        "United States": "en",
        "United Kingdom": "en",
        "Canada": "en",
        "Australia": "en",
        "New Zealand": "en",
        "Japan": "ja",
        "Korea": "ko",
        "Hong Kong": "zh-Hant",
        "Taiwan": "zh-Hant",
        "China": "zh-Hans",
        "Singapore": "en",
        "Germany": "de",
        "France": "fr",
        "Mexico": "es"
    ]
    
    static let countryToMkt = [
        "United States": "en-US",
        "United Kingdom": "en-GB",
        "Canada": "en-CA",
        "Australia": "en-AU",
        "New Zealand": "en-NZ",
        "Japan": "ja-JP",
        "Korea": "ko-KR",
        "Hong Kong": "zh-HK",
        "Taiwan": "zh-TW",
        "China": "zh-CN",
        "Singapore": "en-SG",
        "Germany": "de-DE",
        "France": "fr-FR",
        "Mexico": "es-MX"
    ]
    
    

    static let covidName = [
        "en": "COVID-19",
        "es": "COVID-19",
        "zh-Hans": "新冠肺炎",
        "zh-Hant": "新冠肺炎",
        "ja": "新型コロナ",
        "ko": "코로나",
        "de": "Corona",
        "fr": "Coronavirus"
    ]
    
    
    
    static let languageName = [
        "en": "English",
        "es": "Español",
        "zh-Hans": "简体中文",
        "zh-Hant": "繁體中文",
        "ja": "日本語",
        "ko": "한국어",
        "de": "Deutsch",
        "fr": "Français"
    ]
    
}
