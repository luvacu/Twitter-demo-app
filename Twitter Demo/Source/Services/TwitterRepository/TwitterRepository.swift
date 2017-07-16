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
    private let database: TwitterDatabase
    
    init(userID: String) {
        let client = TWTRAPIClient(userID: userID)
        networkProxy = TwitterNetworkProxy(client: client)
        database = TwitterDatabase()
    }
    
    func retrieveTweets(favouritesOnly: Bool = false) -> Observable<[Tweet]> {
        if favouritesOnly {
            return database.tweets
        } else {
            return networkProxy.retrieveTweets()
        }
    }
    
    func retrieveUser(withID userID: String) -> Single<User> {
        return networkProxy.retrieveUser(withID: userID)
    }
    
    func markTweet(_ tweet: Tweet, asFavourite favourite: Bool) -> Single<Bool> {
        return networkProxy.markTweet(withID: tweet.tweetID, asFavourite: favourite)
            .flatMap { isFavourite in
                
                let databaseCompletable: Completable
                if isFavourite {
                    databaseCompletable = self.database.save(tweet: tweet.withLikeToggled())
                } else {
                    databaseCompletable = self.database.delete(tweetWithID: tweet.tweetID)
                }
                
                return databaseCompletable
                    .then(Observable.just(isFavourite))
                    .asSingle()
            }
    }
}
