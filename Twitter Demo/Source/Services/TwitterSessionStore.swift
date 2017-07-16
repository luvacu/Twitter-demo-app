//
//  TwitterSessionStore.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

struct TwitterSessionStore {
    
    private let sessionStore: TwitterService.SessionStore
    
    init(service: TwitterService) {
        sessionStore = service.sessionStore
    }
    
    var currentUserID: String? {
        return sessionStore.session()?.userID
    }
}
