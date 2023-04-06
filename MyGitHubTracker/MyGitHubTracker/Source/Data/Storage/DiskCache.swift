//
//  DiskCache.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

final class DiskCache: DiskCachable {
    
    static let shared = DiskCache()
    
    private let fileManager = FileManager.default
    private let diskCacheDirectoryUrl: URL? = {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }()
    
    private init() { }
    
    func lookUpData(by key: String, completion: @escaping (Data?) -> Void) {
        guard let filePath = diskCacheDirectoryUrl?.appendingPathComponent(key) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if self.fileManager.fileExists(atPath: filePath.path),
               let data = try? Data(contentsOf: filePath) {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
    
    func storeData(_ data: Data, forKey key: String) {
        guard let diskCacheDirectoryUrl = self.diskCacheDirectoryUrl else { return }
        let filePath = diskCacheDirectoryUrl.appendingPathComponent(key)
        try? data.write(to: filePath)
    }
}
