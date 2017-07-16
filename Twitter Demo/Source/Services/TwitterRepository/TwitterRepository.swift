//
//  TwitterRepository.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 15/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import TwitterKit

struct TwitterRepository {
    
    typealias User = TWTRUser
    typealias Tweet = TWTRTweet
    
    private let networkProxy: TwitterNetworkProxy
    
    init(userID: String) {
        let client = TWTRAPIClient(userID: userID)
        networkProxy = TwitterNetworkProxy(client: client)
    }
    
    func retrieveTweets(favouritesOnly: Bool = false) -> Observable<[Tweet]> {
        // TODO: if favouritesOnly == true, retrieve them from database instead
        return networkProxy.retrieveTweets()
    }
    
    func markTweet(withID tweetID: String, asFavourite favourite: Bool) -> Completable {
        return networkProxy.markTweet(withID: tweetID, asFavourite: favourite)
    }
    
    func retrieveUser(withID userID: String) -> Single<User> {
        return networkProxy.retrieveUser(withID: userID)
    }
}
