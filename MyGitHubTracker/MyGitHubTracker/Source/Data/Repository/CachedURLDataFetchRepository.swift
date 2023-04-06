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
    
    func fetchCachedData(from url: URL) async throws -> Data {
        let imageName = url.lastPathComponent
        
        if let imageData = memoryCache.lookUpData(by: imageName) {
            return imageData
        }
        
        if let data = await diskCache.lookUpData(by: imageName) {
            memoryCache.storeData(data, forKey: imageName)
            return data
        }
        
        do {
            let data = try await urlDataService.fetchData(from: url)
            memoryCache.storeData(data, forKey: imageName)
            diskCache.storeData(data, forKey: imageName)
            return data
        } catch {
            throw error
        }
    }
}
