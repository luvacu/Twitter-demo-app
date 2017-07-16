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
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    let avatarImageURLDriver: Driver<String>
    let userNameTextDriver: Driver<String>
    let dateTextDriver: Driver<String>
    let tweetTextDriver: Driver<String>
    let isFavouriteDriver: Driver<Bool>
    
    init(tweet: TwitterRepository.Tweet) {
        avatarImageURLDriver = Driver.just(tweet.author.profileImageLargeURL)
        userNameTextDriver = Driver.just(tweet.author.formattedScreenName)
        
        let dateFormatter = TweetCellViewModel.dateFormatter
        dateTextDriver = Driver.just(dateFormatter.string(from: tweet.createdAt))
        
        tweetTextDriver = Driver.just(tweet.text)
        isFavouriteDriver = Driver.just(tweet.isLiked)
    }
    
    func toggleFavourite() {
        // TODO:
    }
}
