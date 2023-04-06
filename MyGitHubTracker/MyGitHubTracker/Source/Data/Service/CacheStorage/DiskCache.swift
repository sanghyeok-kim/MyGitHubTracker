//
//  DiskCache.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation
import UIKit.UIImage

final class DiskCache: DiskCachable {
    
    static let shared = DiskCache()
    
    private let fileManager = FileManager.default
    private let diskCacheDirectoryUrl: URL? = {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }()
    
    private init() { }
    
    func lookUpImage(by imageName: String, completion: @escaping (UIImage?) -> Void) {
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
    
    func storeImage(_ image: UIImage, forKey key: String) {
        guard let diskCacheDirectoryUrl = self.diskCacheDirectoryUrl,
              let imageData = image.pngData() else { return }
        let filePath = diskCacheDirectoryUrl.appendingPathComponent(key)
        try? imageData.write(to: filePath)
    }
}
