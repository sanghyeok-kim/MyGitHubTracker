//
//  Rx+validateStatusCode.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift

extension ObservableType where Element == NetworkResult {
    func validateStatusCode() -> Observable<Element> {
        return self.flatMap { networkResult -> Observable<Element> in
            guard 200...299 ~= networkResult.statusCode else {
                return .error(NetworkError.invalidStatusCode(code: networkResult.statusCode))
            }
            return .just(networkResult)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == NetworkResult {
    func validateStatusCode() -> Single<Element> {
        return asObservable().validateStatusCode().asSingle()
    }
}
