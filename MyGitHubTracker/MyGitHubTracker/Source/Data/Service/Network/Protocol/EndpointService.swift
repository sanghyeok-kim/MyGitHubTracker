//
//  EndpointService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/05.
//

import RxSwift

protocol EndpointService {
    func fetchData(endpoint: TargetType, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchData(endpoint: TargetType) async throws -> Data
    func fetchData(endpoint: TargetType) -> Single<Data>
    func fetchStatusCode(endpoint: TargetType) -> Single<Int>
}
