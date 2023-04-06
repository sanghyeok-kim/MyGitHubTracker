//
//  URLSessionURLDataService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

final class URLSessionURLDataService: URLDataService {
    func fetchData(from url: URL, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.errorDetected(error: error)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponseData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
