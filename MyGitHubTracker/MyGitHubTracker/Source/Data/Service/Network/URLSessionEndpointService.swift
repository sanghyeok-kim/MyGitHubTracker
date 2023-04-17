//
//  URLSessionEndpointService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class URLSessionEndpointService: EndpointService {
    
    static let shared = URLSessionEndpointService()
    
    private init() {}
    
    func fetchData<E: Encodable>(
        endpoint: TargetType,
        with objectBody: E,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let request: URLRequest
        
        do {
            request = try buildRequest(from: endpoint, with: objectBody)
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
    
    func fetchData<E: Encodable>(endpoint: TargetType, with objectBody: E) async throws -> Data {
        let request: URLRequest
        
        do {
            request = try buildRequest(from: endpoint, with: objectBody)
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
    
    func fetchData<E: Encodable>(endpoint: TargetType, with bodyObject: E) -> Single<Data> {
        return performRequest(endpoint: endpoint, bodyObject: bodyObject)
            .validateStatusCode()
            .unwrapData()
    }
    
    func fetchStatusCode<E: Encodable>(endpoint: TargetType, with bodyObject: E) -> Single<Int> {
        return performRequest(endpoint: endpoint, bodyObject: bodyObject)
            .map { $0.statusCode }
    }
}

// MARK: - Supporting Methods

private extension URLSessionEndpointService {
    private func buildRequest<E: Encodable>(from endpoint: TargetType, with bodyObject: E) throws -> URLRequest {
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
        
        var request = URLRequest(url: finalUrl, cachePolicy: .reloadRevalidatingCacheData)
        request.httpMethod = endpoint.method.value
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if bodyObject is EmptyBody {
            return request
        }
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(bodyObject)
        } catch {
            throw NetworkError.encodeError
        }
        
        return request
    }
    
    private func performDataTask(with request: URLRequest) -> Single<NetworkResult> {
        return Single.create { single -> Disposable in
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
    
    private func performRequest<E: Encodable>(endpoint: TargetType, bodyObject: E) -> Single<NetworkResult> {
        return Single.create { [weak self] single -> Disposable in
            guard let self = self else {
                single(.failure(NetworkError.objectDeallocated))
                return Disposables.create()
            }
            
            let request: URLRequest
            
            do {
                request = try self.buildRequest(from: endpoint, with: bodyObject)
            } catch {
                single(.failure(NetworkError.invalidRequest))
                return Disposables.create()
            }
            
            return self.performDataTask(with: request)
                .subscribe(onSuccess: { result in
                    single(.success(result))
                }, onFailure: { error in
                    single(.failure(error))
                })
        }
    }
}
