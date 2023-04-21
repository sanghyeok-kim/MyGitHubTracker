//
//  CachedImageLoader.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/11.
//

import RxSwift

@available(*, deprecated, message: "ImageLoader 대신 URLDataUseCase 사용")
protocol ImageLoader {
    func fetchImage(from url: URL) async throws -> UIImage?
    func fetchImage(from url: URL) -> Single<UIImage?>
}
