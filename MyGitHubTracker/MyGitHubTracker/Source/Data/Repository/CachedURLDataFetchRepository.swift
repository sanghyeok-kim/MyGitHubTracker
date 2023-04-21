//
//  CachedURLDataFetchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import RxSwift

final class CachedURLDataFetchRepository: URLDataFetchRepository {
    
    @Inject private var memoryCache: MemoryCachable
    @Inject private var diskCache: DiskCachable
    @Inject private var urlDataService: URLDataService
    
    func fetchCachedData(from url: URL?) async throws -> Data {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        let dataName = url.lastPathComponent
        
        if let data = memoryCache.lookUpData(by: dataName) {
            return data
        }
        
        if let data = await diskCache.lookUpData(by: dataName) {
            memoryCache.storeData(data, forKey: dataName)
            return data
        }
        
        do {
            let data = try await urlDataService.fetchData(from: url)
            memoryCache.storeData(data, forKey: dataName)
            diskCache.storeData(data, forKey: dataName)
            return data
        } catch {
            throw error
        }
    }
    
    func fetchCachedData(from url: URL?) -> Single<Data> {
        guard let url = url else {
            return Single.error(NetworkError.invalidURL)
        }
        
        let dataName = url.lastPathComponent
        
        return fetchFromMemoryCache(dataName: dataName)
            .catch { [weak self] error in
                guard let self = self else { return .error(FileSystemError.objectDeallocated) }
                return self.fetchFromDiskCache(dataName: dataName)
            }
            .catch { [weak self] error in
                guard let self = self else { return .error(FileSystemError.objectDeallocated) }
                return self.fetchFromRemoteAndCache(from: url, dataName: dataName)
            }
    }
}

// MARK: - Supporting Methods

private extension CachedURLDataFetchRepository {
    private func fetchFromMemoryCache(dataName: String) -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FileSystemError.objectDeallocated))
                return Disposables.create()
            }
            
            if let data = self.memoryCache.lookUpData(by: dataName) {
                single(.success(data))
            } else {
                single(.failure(FileSystemError.dataNotFound))
            }
            return Disposables.create()
        }
    }
    
    private func fetchFromDiskCache(dataName: String) -> Single<Data> {
        return diskCache
            .lookUpData(by: dataName)
            .do(onSuccess: { [weak self] data in
                self?.memoryCache.storeData(data, forKey: dataName)
            })
    }
    
    private func fetchFromRemoteAndCache(from url: URL, dataName: String) -> Single<Data> {
        return urlDataService.fetchData(from: url)
            .do(onSuccess: { [weak self] data in
                self?.memoryCache.storeData(data, forKey: dataName)
                self?.diskCache.storeData(data, forKey: dataName)
            })
    }
}
