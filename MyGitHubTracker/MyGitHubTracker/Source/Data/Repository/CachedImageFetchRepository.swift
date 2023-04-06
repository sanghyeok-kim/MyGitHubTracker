//
//  CachedImageFetchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation
import UIKit.UIImage

final class CachedImageFetchRepository: ImageFetchRepository {
    
    static let shared = CachedImageFetchRepository()
    
    @Inject private var memoryCache: MemoryCachable
    @Inject private var diskCache: DiskCachable
    @Inject private var imageFetchService: ImageFetchService
    
    private init() { }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, ImageNetworkError>) -> ()) {
        let imageName = url.lastPathComponent
        
        if let image = memoryCache.lookUpImage(by: imageName) {
            completion(.success(image))
            return
        }
        
        diskCache.lookUpImage(by: imageName) { [weak self] image in
            if let image = image {
                self?.memoryCache.storeImage(image, forKey: imageName)
                completion(.success(image))
            } else {
                self?.imageFetchService.fetchImage(from: url) { [weak self] result in
                    switch result {
                    case .success(let image):
                        self?.memoryCache.storeImage(image, forKey: imageName)
                        self?.diskCache.storeImage(image, forKey: imageName)
                        completion(.success(image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
