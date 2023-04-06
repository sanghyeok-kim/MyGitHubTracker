//
//  ImageCacheService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import UIKit

protocol ImageCacheService {
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage?, ImageNetworkError>) -> ())
}
