//
//  ProfileViewModel.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    private let repository: TwitterRepository
    
    let avatarImageURLDriver: Driver<String>
    let nameTextDriver: Driver<String>
    let userNameTextDriver: Driver<String>
    
    init(repository: TwitterRepository, userID: String) {
        self.repository = repository
        
        let userObservable = repository.retrieveUser(withID: userID)
            .asObservable()
            .share()
        
        avatarImageURLDriver = userObservable
            .map { $0.profileImageLargeURL }
            .asDriver(onErrorJustReturn: "")
            .startWith("…")
        
        nameTextDriver = userObservable
            .map { $0.name }
            .asDriver(onErrorJustReturn: "")
            .startWith("…")
        
        userNameTextDriver = userObservable
            .map { $0.formattedScreenName }
            .asDriver(onErrorJustReturn: "")
            .startWith("…")
    }
}
