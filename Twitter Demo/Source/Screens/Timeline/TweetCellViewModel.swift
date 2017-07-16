//
//  TweetCellViewModel.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class TweetCellViewModel {
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    private let disposeBag = DisposeBag()
    
    private let repository: TwitterRepository
    private let tweet: TwitterRepository.Tweet
    private let isFavourite: Variable<Bool>
    
    let userID: String
    
    let avatarImageURLDriver: Driver<String>
    let userNameTextDriver: Driver<String>
    let dateTextDriver: Driver<String>
    let tweetTextDriver: Driver<String>
    let isFavouriteDriver: Driver<Bool>
    
    init(repository: TwitterRepository, tweet: TwitterRepository.Tweet) {
        self.repository = repository
        self.tweet = tweet
        isFavourite = Variable(tweet.isLiked)
        userID = tweet.author.userID
        
        avatarImageURLDriver = Driver.just(tweet.author.profileImageLargeURL)
        userNameTextDriver = Driver.just(tweet.author.formattedScreenName)
        
        let dateFormatter = TweetCellViewModel.dateFormatter
        dateTextDriver = Driver.just(dateFormatter.string(from: tweet.createdAt))
        
        tweetTextDriver = Driver.just(tweet.text)
        isFavouriteDriver = isFavourite.asDriver()
    }
    
    func toggleFavourite() {
        repository.markTweet(tweet, asFavourite: !isFavourite.value)
            .asObservable()
            .catchErrorJustReturn(isFavourite.value)
            .bind(to: isFavourite)
            .disposed(by: disposeBag)
    }
}
