//
//  Completable+Operators.swift
//  Twitter Demo
//
//  Created by Luis Valdés on 16/7/17.
//  Copyright © 2017 Luis Valdés Cuesta. All rights reserved.
//

import RxSwift

extension PrimitiveSequenceType where TraitType == CompletableTrait, ElementType == Never {
    
    func then<E>(_ observable: Observable<E>) -> Observable<E> {
        return primitiveSequence
            .asObservable()
            .materialize()
            .map { event -> Event<E> in
                switch event {
                case .next:
                    fatalError("Completables should not send Next events")
                case .error(let error):
                    return Event.error(error)
                case .completed:
                    return Event.completed
                }
            }
            .dematerialize()
            .concat(observable)
    }
}
