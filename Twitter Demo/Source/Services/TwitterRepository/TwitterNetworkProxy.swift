//
//  TwitterNetworkProxy.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import TwitterKit

struct TwitterNetworkProxy {
    
    private struct Requests {
        
        static let baseURL = "https://api.twitter.com/1.1/"
        
        struct RetrieveTweets {
            static let method = "GET"
            static let path = "statuses/home_timeline.json"
        }
    }
    
    enum Error: Swift.Error {
        
        /// Retrieving user details from the server returned no user information
        case didNotRetrieveUser(userID: String)
    }
    
    private let client: TWTRAPIClient
    
    init(client: TWTRAPIClient) {
        self.client = client
    }
    
    func retrieveTweets() -> Observable<[TwitterRepository.Tweet]> {
        return Observable.create { observer -> Disposable in
            let request: URLRequest
            do {
                request = try self.urlRequestForHomeTimeline()
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            let progress = self.client.sendTwitterRequest(request) { (_, data, error) in
                DispatchQueue.global(qos: .userInitiated).async {
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }
                    
                    guard let data = data else {
                        observer.onCompleted()
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        guard let jsonArray = json as? [Any],
                            let tweets = TwitterRepository.Tweet.tweets(withJSONArray: jsonArray) as? [TwitterRepository.Tweet] else {
                            observer.onCompleted()
                            return
                        }
                        observer.onNext(tweets)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                progress.cancel()
            }
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }
    
    func markTweet(withID tweetID: String, asFavourite favourite: Bool) -> Completable {
        return Completable.never()
    }
    
    func retrieveUser(withID userID: String) -> Single<TwitterRepository.User> {
        return Single.create { single in
            self.client.loadUser(withID: userID) { user, error in
                guard error == nil else {
                    single(.error(error!))
                    return
                }
                
                guard let user = user else {
                    single(.error(Error.didNotRetrieveUser(userID: userID)))
                    return
                }
                single(.success(user))                
            }
            return Disposables.create()
        }
    }
    
    private func urlRequestForHomeTimeline() throws -> URLRequest {
        let url = Requests.baseURL + Requests.RetrieveTweets.path
        let method = Requests.RetrieveTweets.method
        let params: [AnyHashable : Any]? = nil
        var error: NSError?
        
        let request = client.urlRequest(withMethod: method, url: url, parameters: params, error: &error)
        
        guard error == nil else {
            throw error!
        }
        
        return request
    }
    
//    private func parseTweets(inJSONArray jsonArray: [Any]) -> [TwitterRepository.Tweet] {
//        var tweets: [TwitterRepository.Tweet] = []
//        for jsonObject in jsonArray {
//            if let dictionary = jsonObject as? [AnyHashable : Any],
//                let tweet = TwitterRepository.Tweet(jsonDictionary: dictionary) {
//                tweets.append(tweet)
//            }
//        }
//        return tweets
//    }
}
