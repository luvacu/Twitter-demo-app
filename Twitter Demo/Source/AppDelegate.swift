//
//  AppDelegate.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 15/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator!
    var twitterService: TwitterService!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        twitterService = TwitterService(withConsumerKey: "YourConsumerKey", consumerSecret: "YourConsumerSecret")
        let sessionStore = TwitterSessionStore(service: twitterService)
        
        coordinator = Coordinator(window: window)
        coordinator.setRootViewController(withUserID: sessionStore.currentUserID)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return twitterService.handleApplication(app, open: url, options: options)
    }

}
