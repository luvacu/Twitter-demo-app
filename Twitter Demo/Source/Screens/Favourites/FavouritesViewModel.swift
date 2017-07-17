//
//  FavouritesViewModel.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import Rswift

final class FavouritesViewModel: TimelineViewModel {
    
    var showUserProfile: (String) -> Void = { _ in }
    
    private let repository: TwitterRepository
    
    let windowTitleDriver: Driver<String>
    let windowIconDriver: Driver<Rswift.ImageResource>
    let tweetsDriver: Driver<[TweetCellViewModel]>
    
    init(repository: TwitterRepository) {
        self.repository = repository
        
        windowTitleDriver = Driver.just("Favourites")
        windowIconDriver = Driver.just(R.image.heartFilledIcon)
        
        tweetsDriver = repository.retrieveTweets(favouritesOnly: true)
            .map { tweets in
                tweets.map { TweetCellViewModel(repository: repository, tweet: $0) }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func didSelectCellViewModel(_ cellViewModel: TweetCellViewModel) {
        showUserProfile(cellViewModel.userID)
    }

}
