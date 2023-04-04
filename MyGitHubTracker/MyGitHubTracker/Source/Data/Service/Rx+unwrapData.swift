//
//  Rx+unwrapData.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift

extension ObservableType where Element == NetworkResult {
    func unwrapData() -> Observable<Data> {
        return flatMap { networkResult -> Observable<Data> in
            guard let data = networkResult.data else {
                return .error(NetworkError.invalidResponseData)
            }
            return .just(data)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == NetworkResult {
    func unwrapData() -> Single<Data> {
        return asObservable().unwrapData().asSingle()
    }
}
