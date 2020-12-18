//
//  AppDelegate.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/20/20.
//

import UIKit
import RealmSwift
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let locale = Locale.current
        var defaultLang = "en-US"
        if let safe_lang = locale.languageCode{
            defaultLang = safe_lang
        }
        
        if UserDefaults.standard.string(forKey: "defaultLang") == nil {
            UserDefaults.standard.set(defaultLang, forKey: "defaultLang")
        }
        
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        if UserDefaults.standard.string(forKey: "initialized") == nil {
            UserDefaults.standard.set(true, forKey: "initialized")
            CovidDataInRealm.addDataToRealm(name: "San Francisco", order: 0, county: "San Francisco", state: "California", country: "United States")
            CovidDataInRealm.addDataToRealm(name: "Los Angeles", order: 0, county: "Los Angeles", state: "California", country: "United States")
            CovidDataInRealm.addDataToRealm(name: "香港", order: 0, county: "", state: "", country: "Hong Kong")
            CovidDataInRealm.addDataToRealm(name: "Singapore", order: 0, county: "", state: "", country: "Singapore")
            CovidDataInRealm.addDataToRealm(name: "Deutschland", order: 0, county: "", state: "", country: "Germany")
        }
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        GMSServices.provideAPIKey("AIzaSyA71lGqDushBuMVbwmCtfK2lw3wEEjtnQI")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

