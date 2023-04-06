//
//  URLSessionURLDataService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

final class URLSessionURLDataService: URLDataService {
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
}
