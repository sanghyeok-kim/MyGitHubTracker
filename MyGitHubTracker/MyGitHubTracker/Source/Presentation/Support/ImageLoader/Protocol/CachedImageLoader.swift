//
//  CachedImageLoader.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/11.
//

import RxSwift

protocol ImageLoader {
    func fetchImage(from url: URL) async throws -> UIImage?
    func fetchImage(from url: URL) -> Single<UIImage?>
}
