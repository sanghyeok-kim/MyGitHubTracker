//
//  CachedURLDataFetchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

final class CachedURLDataFetchRepository: URLDataFetchRepository {
    
    static let shared = CachedURLDataFetchRepository()
    
    @Inject private var memoryCache: MemoryCachable
    @Inject private var diskCache: DiskCachable
    @Inject private var urlDataService: URLDataService
    
    private init() { }
    
    func fetch(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        let dataName = url.lastPathComponent
        
        if let data = memoryCache.lookUpData(by: dataName) {
            completion(.success(data))
            return
        }
        
        diskCache.lookUpData(by: dataName) { [weak self] data in
            if let data = data {
                self?.memoryCache.storeData(data, forKey: dataName)
                completion(.success(data))
            } else {
                self?.urlDataService.fetchData(from: url) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.memoryCache.storeData(data, forKey: dataName)
                        self?.diskCache.storeData(data, forKey: dataName)
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
