//
//  URLSessionImageCacheService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import UIKit

final class URLSessionImageCacheService: ImageCacheService {
    
    static let shared = URLSessionImageCacheService()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    private let diskCacheDirectoryUrl: URL? = {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }()
    
    private init() { }
    
    private func lookUpImageOnMemory(by imageName: String) -> UIImage? {
        let cachedImage = memoryCache.object(forKey: imageName as NSString)
        return cachedImage
    }
    
    private func lookUpImageOnDisk(by imageName: String) -> UIImage? {
        guard let diskCacheDirectoryUrl = self.diskCacheDirectoryUrl else { return nil }
        let filePath = diskCacheDirectoryUrl.appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let image = UIImage(data: imageData) else { return nil }
            return image
        } else {
            return nil
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping((Result<UIImage?, ImageNetworkError>) -> Void)) {
        URLSession.shared.downloadTask(with: url) { [weak self] location, response, error in
            if let error = error {
                completion(.failure(.errorDetected(error: error)))
                return
            }
            
            guard let tempDirectoryUrl = location else {
                completion(.failure(.invalidFileLocation))
                return
            }
            
            let imageName = url.lastPathComponent
            
            //disk caching
            guard let diskCacheDirectoryUrl = self?.diskCacheDirectoryUrl else { return }
            let destinationUrl = diskCacheDirectoryUrl.appendingPathComponent(imageName)
            try? self?.fileManager.copyItem(at: tempDirectoryUrl, to: destinationUrl)
            
            //memory caching
            guard let imageData = try? Data(contentsOf: destinationUrl),
                  let image = UIImage(data: imageData) else { return }
            let imageSize = imageData.count
            self?.memoryCache.setObject(image, forKey: imageName as NSString, cost: imageSize)
            
            completion(.success(image))
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage?, ImageNetworkError>) -> ()) {
        let imageName = url.lastPathComponent
        
        if let image = lookUpImageOnMemory(by: imageName) {
            completion(.success(image))
            return
        }
        
        if let image = lookUpImageOnDisk(by: imageName) {
            memoryCache.setObject(image, forKey: imageName as NSString)
            completion(.success(image))
            return
        }
        
        downloadImage(from: url, completion: completion)
    }
}
