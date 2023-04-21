//
//  CachedURLDataFetchUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/10.
//

import RxSwift

@available(*, deprecated, message: "ImageLoader 대신 URLDataUseCase 사용")
final class CachedImageLoader: ImageLoader {
    
    @Inject private var cachedURLDataFetchRepository: URLDataFetchRepository
    
    func fetchImage(from url: URL) async throws -> UIImage? {
        let data = try await cachedURLDataFetchRepository.fetchCachedData(from: url)
        return UIImage(data: data)
    }
    
    func fetchImage(from url: URL) -> Single<UIImage?> {
        return cachedURLDataFetchRepository
            .fetchCachedData(from: url)
            .map { UIImage(data: $0) }
    }
}
