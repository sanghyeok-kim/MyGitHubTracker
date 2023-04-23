//
//  Rx+imageMap.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/22.
//

import RxSwift
import RxCocoa

extension ObservableType where Element == Data {
    func imageMap() -> Observable<UIImage?> {
        return self.observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { data in
                return UIImage(data: data)
            }
            .observe(on: MainScheduler.instance)
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element == Data {
    func imageMap() -> SharedSequence<SharingStrategy, UIImage?> {
        return self.asObservable()
            .imageMap()
            .asDriver(onErrorJustReturn: nil)
    }
}
