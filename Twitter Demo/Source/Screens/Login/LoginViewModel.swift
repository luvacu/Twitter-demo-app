//
//  LoginViewModel.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class LoginViewModel {
    
    var completionHandler: (String) -> Void = { _ in }
    
    let titleDriver: Driver<String>
    let subTitleDriver: Driver<String>
    private(set) var loginHandler: TwitterService.LogInHandler = { _ in }
    
    init() {
        titleDriver = Driver.just("Welcome to the Twitter Demo app!")
        subTitleDriver = Driver.just("Please log in with your Twitter account first")
        loginHandler = { [unowned self] session, error in
            guard let session = session else {
                print("Error loging in: \(error)")
                return
            }
            print("Successfully logged in with user @\(session.userName)")
            self.completionHandler(session.userID)
        }
    }
}
