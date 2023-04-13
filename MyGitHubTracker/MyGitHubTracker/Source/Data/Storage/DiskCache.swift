//
//  DiskCache.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import RxSwift

final class DiskCache: DiskCachable {
    
    static let shared = DiskCache()
    
    private let fileManager = FileManager.default
    private let diskCacheDirectoryUrl: URL? = {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }()
    
    private init() { }
    
    func lookUpData(by key: String) async -> Data? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let filePath = self.diskCacheDirectoryUrl?.appendingPathComponent(key) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                if self.fileManager.fileExists(atPath: filePath.path),
                   let data = try? Data(contentsOf: filePath) {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
        
    }
    
    func lookUpData(by key: String) -> Single<Data> {
        return Single<Data>.create { [weak self] single in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let self = self else {
                    single(.failure(FileSystemError.objectDeallocated))
                    return
                }
                
                guard let filePath = self.diskCacheDirectoryUrl?.appendingPathComponent(key) else {
                    single(.failure(FileSystemError.invalidFilePath))
                    return
                }
                
                if self.fileManager.fileExists(atPath: filePath.path),
                   let data = try? Data(contentsOf: filePath) {
                    single(.success(data))
                } else {
                    single(.failure(FileSystemError.dataNotFound))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func storeData(_ data: Data, forKey key: String) {
        DispatchQueue.global(qos: .background).async {
            guard let diskCacheDirectoryUrl = self.diskCacheDirectoryUrl else { return }
            let filePath = diskCacheDirectoryUrl.appendingPathComponent(key)
            try? data.write(to: filePath)
        }
    }
}
