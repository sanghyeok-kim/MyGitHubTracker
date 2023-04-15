//
//  MemoryCache.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

final class MemoryCache: MemoryCachable {
    static let shared = MemoryCache()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() { }
    
    func lookUpData(by key: String) -> Data? {
        let cachedData = cache.object(forKey: key as NSString)
        return cachedData as Data?
    }
    
    func storeData(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString, cost: data.count)
    }
}
