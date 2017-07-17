//
//  TwitterDatabase.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift

final class TwitterDatabase {
    
    enum Error: Swift.Error {
        case databaseReferenceNoLongerExists
    }
    
    struct Keys {
        static let tweets = "tweets"
    }
    
    // TODO: Replace with a proper DBMS like Realm or CoreData
    private let database: UserDefaults
    
    private var tweetsDictionary: [String: Data] {
        get {
            guard let dictionary = database.dictionary(forKey: Keys.tweets) as? [String: Data] else {
                let dictionary: [String: Data] = [:]
                database.set(dictionary, forKey: Keys.tweets)
                database.synchronize()
                return dictionary
            }
            return dictionary
        }
        set {
            database.set(newValue, forKey: Keys.tweets)
            database.synchronize()
            
            let tweetsArray = newValue.flatMap { (_, data) in
                TweetBuilder.tweetFrom(data)
            }
            tweets.value = tweetsArray
        }
    }
    
    private(set) lazy var tweets: Variable<[TwitterRepository.Tweet]> = { [unowned self] in
        let tweetsArray = self.tweetsDictionary.flatMap { (_, data) in
            TweetBuilder.tweetFrom(data)
        }
        return Variable(tweetsArray)
    }()
    
    init() {
        database = UserDefaults.standard
    }
    
    func save(tweet: TwitterRepository.Tweet) -> Completable {
        return Completable.create { [weak self] completable -> Disposable in
            guard let `self` = self else {
                completable(.error(Error.databaseReferenceNoLongerExists))
                return Disposables.create()
            }
            
            let tweetData = TweetBuilder.tweetAsData(tweet)
            self.tweetsDictionary[tweet.tweetID] = tweetData
            
            completable(.completed)
            
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }
    
    func delete(tweetWithID tweetID: String) -> Completable {
        return Completable.create { [weak self] completable -> Disposable in
            guard let `self` = self else {
                completable(.error(Error.databaseReferenceNoLongerExists))
                return Disposables.create()
            }
            
            self.tweetsDictionary[tweetID] = nil
            
            completable(.completed)
            
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }
}

/// This struct should be a private extension for TwitterRepository.Tweet, but the compiler crashes.
private struct TweetBuilder {
    
    static func tweetFrom(_ data: Data) -> TwitterRepository.Tweet? {
        guard let tweet = NSKeyedUnarchiver.unarchiveObject(with: data) as? TwitterRepository.Tweet else {
            return nil
        }
        return tweet
    }
    
    static func tweetAsData(_ tweet: TwitterRepository.Tweet) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: tweet)
    }
}
