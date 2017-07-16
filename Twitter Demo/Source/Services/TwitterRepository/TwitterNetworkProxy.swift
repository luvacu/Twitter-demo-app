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
        
        struct Timeline {
            static let method = "GET"
            static let path = "statuses/home_timeline.json"
        }
        
        struct Favourites {
            static let method = "POST"
            static let paramID = "id"
            
            static let createPath = "favorites/create.json"
            static let destroyPath = "favorites/destroy.json"
        }
    }
    
    enum Error: Swift.Error {
        
        /// The server returned no data as a response
        case didNotReceiveData
        
        /// The server returned data in a different format than expected
        case invalidDataFormat
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
    
    func retrieveUser(withID userID: String) -> Single<TwitterRepository.User> {
        return Single.create { single in
            self.client.loadUser(withID: userID) { user, error in
                guard error == nil else {
                    single(.error(error!))
                    return
                }
                
                guard let user = user else {
                    single(.error(Error.didNotReceiveData))
                    return
                }
                single(.success(user))                
            }
            return Disposables.create()
        }
    }
    
    func markTweet(withID tweetID: String, asFavourite favourite: Bool) -> Single<Bool> {
        return Single.create { single -> Disposable in
            let request: URLRequest
            do {
                request = try self.urlRequestToMarkTweet(withID: tweetID, asFavourite: favourite)
            } catch {
                single(.error(error))
                return Disposables.create()
            }
            
            let progress = self.client.sendTwitterRequest(request) { (_, data, error) in
                DispatchQueue.global(qos: .userInitiated).async {
                    guard error == nil else {
                        single(.error(error!))
                        return
                    }
                    
                    guard let data = data else {
                        single(.error(Error.didNotReceiveData))
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let jsonObject = json as? [AnyHashable : Any],
                            let tweet = TwitterRepository.Tweet(jsonDictionary: jsonObject) else {
                                single(.error(Error.didNotReceiveData))
                                return
                        }
                        single(.success(tweet.isLiked))
                    } catch {
                        single(.error(error))
                    }
                }
            }
            return Disposables.create {
                progress.cancel()
            }
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }
    
    private func urlRequestForHomeTimeline() throws -> URLRequest {
        let url = Requests.baseURL + Requests.Timeline.path
        let method = Requests.Timeline.method
        let params: [AnyHashable : Any]? = nil
        
        return try urlRequest(method: method, url: url, parameters: params)
    }
    
    private func urlRequestToMarkTweet(withID tweetID: String, asFavourite favourite: Bool) throws -> URLRequest {
        let url = Requests.baseURL + (favourite ? Requests.Favourites.createPath : Requests.Favourites.destroyPath)
        let method = Requests.Favourites.method
        let params = [Requests.Favourites.paramID : tweetID]
        
        return try urlRequest(method: method, url: url, parameters: params)
    }
    
    private func urlRequest(method: String, url: String, parameters: [AnyHashable : Any]?) throws -> URLRequest {
        var error: NSError?
        let request = client.urlRequest(withMethod: method, url: url, parameters: parameters, error: &error)
        guard error == nil else {
            throw error!
        }
        return request
    }

}
