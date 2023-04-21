//
//  CachedURLDataUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/21.
//

import RxSwift

final class CachedURLDataUseCase: URLDataUseCase {
    
    private var currentDisposable: Disposable?
    @Inject private var urlDataFetchRepository: URLDataFetchRepository
    
    func fetch(from url: URL?) async throws -> Data {
        let task = Task { [weak self] in
            guard let self = self else {
                throw NetworkError.objectDeallocated
            }
            return try await self.urlDataFetchRepository.fetchCachedData(from: url)
        }
        
        let data = try await task.value
        return data
    }
    
    func fetch(from url: URL?) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            let observable = self?.urlDataFetchRepository.fetchCachedData(from: url).asObservable()
            let disposable = observable?.subscribe { event in
                observer.on(event)
            }
            self?.currentDisposable = disposable
            return Disposables.create()
        }
    }
    
    func cancel() {
        currentDisposable?.dispose()
    }
}
