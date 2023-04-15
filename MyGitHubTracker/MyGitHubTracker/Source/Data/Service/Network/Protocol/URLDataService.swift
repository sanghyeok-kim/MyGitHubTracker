//
//  URLDataService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import RxSwift

protocol URLDataService {
    func fetchData(from url: URL) async throws -> Data
    func fetchData(from url: URL) -> Single<Data>
}
