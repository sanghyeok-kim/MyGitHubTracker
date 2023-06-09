//
//  Rx+UIImageView+loadImage.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/15.
//

import RxSwift

extension Reactive where Base: UIImageView {
    @available(*, deprecated, message: "ImageLoader 대신 URLDataUseCase 사용")
    func loadImage(using imageLoader: ImageLoader, disposeBag: DisposeBag) -> Binder<URL> {
        return Binder(base) { imageView, url in
            imageView
                .setImageWithCaching(from: url, using: imageLoader)
                .disposed(by: disposeBag)
        }
    }
}
