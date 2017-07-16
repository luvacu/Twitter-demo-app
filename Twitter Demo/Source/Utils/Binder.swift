//
//  Binder.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol Binder {
    
    var disposeBag: DisposeBag { get }
    
    func bind<D: SharedSequenceConvertibleType, O: ObserverType>(_ driver: D, to observer: O) where D.SharingStrategy == DriverSharingStrategy, D.E == O.E
    
    func bind<D: SharedSequenceConvertibleType, O: ObserverType>(_ driver: D, to observer: O) where D.SharingStrategy == DriverSharingStrategy, O.E == D.E?
}

extension Binder {
    
    func bind<D: SharedSequenceConvertibleType, O: ObserverType>(_ driver: D, to observer: O) where D.SharingStrategy == DriverSharingStrategy, D.E == O.E {
        driver.drive(observer)
            .disposed(by: disposeBag)
    }
    
    func bind<D: SharedSequenceConvertibleType, O: ObserverType>(_ driver: D, to observer: O) where D.SharingStrategy == DriverSharingStrategy, O.E == D.E? {
        driver.drive(observer)
            .disposed(by: disposeBag)
    }
}
