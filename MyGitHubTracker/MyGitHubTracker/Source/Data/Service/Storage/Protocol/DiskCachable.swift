//
//  DiskCachable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import RxSwift

protocol DiskCachable {
    func lookUpData(by key: String) async -> Data?
    func lookUpData(by key: String) -> Single<Data>
    func storeData(_ data: Data, forKey key: String)
}
