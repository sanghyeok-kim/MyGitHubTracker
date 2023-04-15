//
//  URLSessionURLDataService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import RxSwift

final class URLSessionURLDataService: URLDataService {
    
    static let shared = URLSessionURLDataService()
    
    private init() {}
    
    func fetchData(from url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: NetworkError.errorDetected(error: error))
                } else if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: NetworkError.invalidResponseData)
                }
            }.resume()
        }
    }
    
    func fetchData(from url: URL) -> Single<Data> {
        return Single<Data>.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(NetworkError.errorDetected(error: error)))
                } else if let data = data {
                    single(.success(data))
                } else {
                    single(.failure(NetworkError.invalidResponseData))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
