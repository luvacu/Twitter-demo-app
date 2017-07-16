//
//  TwitterService.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import TwitterKit

struct TwitterService {
    
    typealias SessionStore = TWTRSessionStore
    
    typealias LogInButton = TWTRLogInButton
    typealias LogInHandler = TWTRLogInCompletion
    
    init(withConsumerKey consumerKey: String, consumerSecret: String) {
        Twitter.sharedInstance().start(withConsumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    var sessionStore: SessionStore {
        return Twitter.sharedInstance().sessionStore
    }
    
    func handleApplication(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
}
