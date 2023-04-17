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
        return urlSessionNetworkService
            .fetchStatusCode(
                endpoint: GitHubAPI.starRepository(ownerName: ownerName, repositoryName: repositoryName)
            )
            .asCompletableForStatusCode(expected: 204)
    }
    
    func unstarRepository(ownerName: String, repositoryName: String) -> Completable {
        return urlSessionNetworkService
            .fetchStatusCode(
                endpoint: GitHubAPI.unstarRepository(ownerName: ownerName, repositoryName: repositoryName)
            )
            .asCompletableForStatusCode(expected: 204)
    }
}
