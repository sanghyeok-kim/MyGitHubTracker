//
//  Rx+decodeMap.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

extension ObservableType where Element == Data {
    func decodeMap<T: Decodable>(_ type: T.Type) -> Observable<T> {
        return map { data in
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.decodeError
            }
            return decodedData
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Data {
    func decodeMap<T: Decodable>(_ type: T.Type) -> Single<T> {
        return asObservable().decodeMap(type).asSingle()
    }
}

