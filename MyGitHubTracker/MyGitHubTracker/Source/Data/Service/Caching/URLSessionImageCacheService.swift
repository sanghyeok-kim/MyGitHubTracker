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
    
    private func lookUpImageOnDisk(by imageName: String, completion: @escaping (UIImage?) -> Void) {
        guard let filePath = diskCacheDirectoryUrl?.appendingPathComponent(imageName) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if self.fileManager.fileExists(atPath: filePath.path),
               let imageData = try? Data(contentsOf: filePath),
               let image = UIImage(data: imageData) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping((Result<UIImage?, ImageNetworkError>) -> Void)) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.errorDetected(error: error)))
                return
            }
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                completion(.failure(.invalidImageData))
                return
            }
            
            let imageName = url.lastPathComponent
            
            //disk caching
            if let destinationUrl = self?.diskCacheDirectoryUrl?.appendingPathComponent(imageName) {
                do {
                    try imageData.write(to: destinationUrl)
                } catch {
                    completion(.failure(.invalidFileLocation))
                    return
                }
            }
            
            //memory caching
            self?.memoryCache.setObject(image, forKey: imageName as NSString)
            
            completion(.success(image))
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage?, ImageNetworkError>) -> ()) {
        let imageName = url.lastPathComponent
        
        if let image = lookUpImageOnMemory(by: imageName) {
            completion(.success(image))
            return
        }
        
        lookUpImageOnDisk(by: imageName) { [weak self] image in
            if let image = image {
                self?.memoryCache.setObject(image, forKey: imageName as NSString)
                completion(.success(image))
            } else {
                self?.downloadImage(from: url, completion: completion)
            }
        }
    }
}
