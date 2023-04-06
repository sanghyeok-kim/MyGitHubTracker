//
//  ImageFetchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation
import UIKit.UIImage

protocol ImageFetchRepository {
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, ImageNetworkError>) -> ())
}
