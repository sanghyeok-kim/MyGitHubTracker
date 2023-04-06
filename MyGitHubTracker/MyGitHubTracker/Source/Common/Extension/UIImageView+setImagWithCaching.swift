//
//  UIImageView+setImagWithCaching.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import UIKit.UIImageView

extension UIImageView {
    func setImageWithCaching(from url: URL) async {
        do {
            let data = try await CachedURLDataFetchRepository.shared.fetchCachedData(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            }
        } catch {
            CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
        }
    }
}
