//
//  URLSessionImageFetchService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation
import UIKit.UIImage

final class URLSessionImageFetchService: ImageFetchService {
    func fetchImage(from url: URL, completion: @escaping ((Result<UIImage, ImageNetworkError>) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.errorDetected(error: error)))
                return
            }
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                completion(.failure(.invalidImageData))
                return
            }
            
            completion(.success(image))
        }.resume()
    }
}
