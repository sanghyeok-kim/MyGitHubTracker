//
//  UIImageView+setImagWithCaching.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import UIKit.UIImageView
import RxSwift

extension UIImageView {
    func setImageWithCaching(from url: URL, using imageLoader: ImageLoader) async {
        do {
            let image = try await imageLoader.fetchImage(from: url)
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        } catch {
            image = UIImage(systemName: "exclamationmark.triangle")
            CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
        }
    }
    
    func setImageWithCaching(from url: URL, using imageLoader: ImageLoader) -> Disposable {
        return imageLoader
            .fetchImage(from: url)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onSuccess: { `self`, image in
                self.image = image
            }, onFailure: { `self`, error in
                self.image = UIImage(systemName: "exclamationmark.triangle")
                CustomLogger.log(message: error.localizedDescription, category: .network)
            })
    }
}
