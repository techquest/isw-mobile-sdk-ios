//
//  AppDelegate.swift
//  Isw Payment SDK iOS
//
//  Created by ebi igweze on 01/01/2020.
//  Copyright © 2020 Interswitch. All rights reserved.
//

import UIKit
import IswMobileSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // get the configuration from plist file
        if let preparedConfig = getConfigFromProps() {
            
            // create sdk configuration
            let config = IswSdkConfig(clientId: preparedConfig.clientId,
                                      clientSecret: preparedConfig.clientSecret,
                                      currencyCode: preparedConfig.currencyCode,
                                      merchantCode: preparedConfig.merchantCode)
            
            // initialize mobile sdk
            IswMobileSdk.intialize(config: config, env: .test)
        }
        
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
    
    
    
    private func getConfigFromProps() -> Config? {
        // get configuration stored in Preference.plist file
        if  let path = Bundle.main.path(forResource: "Preference", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let config = try? PropertyListDecoder().decode(Config.self, from: xml) {
        
            // return extracted config
            return config
        }
        
        return nil
    }


}

