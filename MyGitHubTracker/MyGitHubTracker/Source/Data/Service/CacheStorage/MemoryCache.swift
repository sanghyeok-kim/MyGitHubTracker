//
//  MemoryCache.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation
import UIKit.UIImage

final class MemoryCache: MemoryCachable {
    
    static let shared = MemoryCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func lookUpImage(by imageName: String) -> UIImage? {
        let cachedImage = cache.object(forKey: imageName as NSString)
        return cachedImage
    }
    
    func storeImage(_ image: UIImage, forKey key: String) {
        let imageSize = image.pngData()?.count ?? 0
        cache.setObject(image, forKey: key as NSString, cost: imageSize)
    }
}
