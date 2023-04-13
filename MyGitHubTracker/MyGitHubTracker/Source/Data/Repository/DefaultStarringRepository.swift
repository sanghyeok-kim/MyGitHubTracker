//
//  DefaultStarringRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift

final class DefaultStarringRepository: StarringRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    private let disposeBag = DisposeBag()
    
    func checkRepositoryIsStarred(ownerName: String, repositoryName: String) -> Single<Bool> {
        return urlSessionNetworkService
            .fetchStatusCode(
                endpoint: GitHubAPI.checkRepositoryIsStarredByUser(ownerName: ownerName, repositoryName: repositoryName)
            )
        .map { $0 == 204 }
    }
    
    func starRepository(ownerName: String, repositoryName: String) -> Completable {
        return performStarring(
            endpoint: GitHubAPI.starRepository(ownerName: ownerName, repositoryName: repositoryName)
        )
    }
    
    func unstarRepository(ownerName: String, repositoryName: String) -> Completable {
        return performStarring(
            endpoint: GitHubAPI.unstarRepository(ownerName: ownerName, repositoryName: repositoryName)
        )
    }
}

// MARK: - Supporting Methods

private extension DefaultStarringRepository {
    func performStarring(endpoint: GitHubAPI) -> Completable {
        return Completable.create { [weak self] observer in
            guard let self = self else {
                observer(.error(NetworkError.objectDeallocated))
                return Disposables.create()
            }
            
            self.urlSessionNetworkService
                .fetchStatusCode(endpoint: endpoint)
                .subscribe(onSuccess: { statusCode in
                    if statusCode == 204 {
                        observer(.completed)
                    } else {
                        observer(.error(NetworkError.invalidStatusCode(code: statusCode)))
                    }
                }, onFailure: { error in
                    observer(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
