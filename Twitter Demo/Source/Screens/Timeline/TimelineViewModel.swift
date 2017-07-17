//
//  TimelineViewModel.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import Rswift

protocol TimelineViewModel {
    
    var windowTitleDriver: Driver<String> { get }
    var windowIconDriver: Driver<Rswift.ImageResource> { get }
    var tweetsDriver: Driver<[TweetCellViewModel]> { get }
    
    func didSelectCellViewModel(_ cellViewModel: TweetCellViewModel)
}
