//
//  Rx+flatMapCompletableMaterialized.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/11.
//

import RxSwift

extension ObservableType {
    func flatMapCompletableMaterialized(_ selector: @escaping (Element) -> Completable) -> Observable<Event<Void>> {
        return self.flatMap {
            selector($0).andThen(Observable.just(())).materialize()
        }
    }
    
    func flatMapLatestCompletableMaterialized(_ selector: @escaping (Element) -> Completable) -> Observable<Event<Void>> {
        return self.flatMapLatest {
            selector($0).andThen(Observable.just(())).materialize()
        }
    }
    
    func flatMapFirstCompletableMaterialized(_ selector: @escaping (Element) -> Completable) -> Observable<Event<Void>> {
        return self.flatMapFirst {
            selector($0).andThen(Observable.just(())).materialize()
        }
    }
}
