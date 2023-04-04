//
//  URLSessionNetworkService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

protocol URLSessionNetworkService {
    func fetchData(endpoint: TargetType, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchData(endpoint: TargetType) async throws -> Data
    func fetchData(endpoint: TargetType) -> Single<Data>
}

final class DefaultURLSessionService: URLSessionNetworkService {
    
    static let shared = DefaultURLSessionService()
    
    private init() {}
    
    func fetchData(endpoint: TargetType, completion: @escaping (Result<Data, Error>) -> Void) {
        let request: URLRequest
        
        do {
            request = try buildRequest(from: endpoint)
        } catch {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.errorDetected(error: error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard 200...299 ~= response.statusCode else {
                completion(.failure(NetworkError.invalidStatusCode(code: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponseData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func fetchData(endpoint: TargetType) async throws -> Data {
        let request: URLRequest
        
        do {
            request = try buildRequest(from: endpoint)
        } catch {
            throw NetworkError.invalidRequest
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidStatusCode(code: httpResponse.statusCode)
            }
            
            return data
        } catch {
            if let urlError = error as? URLError {
                throw NetworkError.errorDetected(error: urlError)
            } else {
                throw error
            }
        }
    }
    
    func fetchData(endpoint: TargetType) -> Single<Data> {
    }
}

// MARK: - Supporting Methods

private extension DefaultURLSessionService {
    private func buildRequest(from endpoint: TargetType) throws -> URLRequest {
        guard let url = endpoint.baseURL?.appendingPathComponent(endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            throw NetworkError.invalidURL
        }
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        }
        
        guard let finalUrl = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = endpoint.method.value
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    private func performRequest(endpoint: TargetType) -> Single<NetworkResult> {
        return Single.create { [weak self] single -> Disposable in
            guard let self = self else {
                single(.failure(NetworkError.objectDeallocated))
                return Disposables.create()
            }
            
            let request: URLRequest
            
            do {
                request = try self.buildRequest(from: endpoint)
            } catch {
                single(.failure(NetworkError.invalidRequest))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(NetworkError.errorDetected(error: error)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    single(.failure(NetworkError.invalidResponse))
                    return
                }
                
                single(.success(NetworkResult(data: data, response: response)))
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
