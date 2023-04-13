//
//  URLDataFetchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import RxSwift

protocol URLDataFetchRepository {
    func fetchCachedData(from url: URL) async throws -> Data
    func fetchCachedData(from url: URL) -> Single<Data>
}
