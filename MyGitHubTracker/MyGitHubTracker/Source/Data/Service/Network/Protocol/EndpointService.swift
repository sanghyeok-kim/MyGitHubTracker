//
//  EndpointService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/05.
//

import RxSwift

protocol EndpointService {
    func fetchData<E: Encodable>(endpoint: TargetType, with objectBody: E, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchData<E: Encodable>(endpoint: TargetType, with objectBody: E) async throws -> Data
    func fetchData<E: Encodable>(endpoint: TargetType, with bodyObject: E) -> Single<Data>
    func fetchStatusCode<E: Encodable>(endpoint: TargetType, with bodyObject: E) -> Single<Int>
}

extension EndpointService {
    func fetchData(endpoint: TargetType, completion: @escaping (Result<Data, Error>) -> Void) {
        fetchData(endpoint: endpoint, with: EmptyBody(), completion: completion)
    }
    
    func fetchData(endpoint: TargetType) async throws -> Data {
        try await fetchData(endpoint: endpoint, with: EmptyBody())
    }
    
    func fetchData(endpoint: TargetType) -> Single<Data> {
        fetchData(endpoint: endpoint, with: EmptyBody())
    }
    
    func fetchStatusCode(endpoint: TargetType) -> Single<Int> {
        fetchStatusCode(endpoint: endpoint, with: EmptyBody())
    }
}
