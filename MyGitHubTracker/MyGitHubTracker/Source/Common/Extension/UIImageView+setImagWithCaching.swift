//
//  UIImageView+setImagWithCaching.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import UIKit.UIImageView

extension UIImageView {
    func setImageWithCaching(from url: URL) {
        CachedURLDataFetchRepository.shared.fetch(from: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(data: image)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
