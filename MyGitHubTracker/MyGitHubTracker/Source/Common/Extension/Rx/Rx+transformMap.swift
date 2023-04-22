//
//  Rx+transformMap.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

// MARK: - For Non-Sequence Element

extension ObservableType {
    func transformMap<T: DataMapper>(_ mapper: T) -> Observable<T.Output> where Element == T.Input {
        return map { element in
            return mapper.transform(element)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    func transformMap<T: DataMapper>(_ mapper: T) -> Single<T.Output> where Element == T.Input {
        return asObservable().transformMap(mapper).asSingle()
    }
}

// MARK: - For Sequence Element

extension ObservableType where Element: Sequence {
    func transformMap<T: DataMapper>(_ mapper: T) -> Observable<[T.Output]> where Element.Element == T.Input {
        return map { sequenceElement in
            return sequenceElement.map { mapper.transform($0) }
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    func transformMap<T: DataMapper>(_ mapper: T) -> Single<[T.Output]> where Element == [T.Input] {
        return asObservable().transformMap(mapper).asSingle()
    }
}
