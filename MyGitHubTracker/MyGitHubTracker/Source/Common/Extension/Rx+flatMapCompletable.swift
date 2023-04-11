//
//  Rx+flatMapCompletable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/11.
//

import RxSwift

extension ObservableType {
    func flatMapCompletable(_ selector: @escaping (Element) -> Completable) -> Observable<Void> {
        return self.flatMap {
            selector($0).andThen(Observable.just(()))
        }
    }
}
