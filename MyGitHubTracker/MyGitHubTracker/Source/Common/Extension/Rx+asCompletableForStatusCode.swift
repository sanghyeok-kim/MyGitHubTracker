//
//  Rx+asCompletableForStatusCode.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Int {
    func asCompletableForStatusCode(expected: Int) -> Completable {
        return self.asObservable().flatMap { result -> Completable in
            if result == expected {
                return Completable.empty()
            } else {
                return Completable.error(NetworkError.invalidStatusCode(code: result))
            }
        }.asCompletable()
    }
}
