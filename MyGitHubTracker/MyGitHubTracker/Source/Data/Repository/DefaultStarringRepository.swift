//
//  DefaultStarringRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift
import RxRelay

final class DefaultStarringRepository: StarringRepository {
    
    @Inject private var urlSessionNetworkService: URLSessionNetworkService
    
    func checkRepositoryIsStarred(repositoryOwner: String, repositoryName: String) -> Single<Bool> {
        return urlSessionNetworkService
            .fetchStatusCode(
                endpoint: GitHubAPI.checkRepositoryIsStarredByUser(
                repositoryOwner: repositoryOwner,
                repositoryName: repositoryName)
            )
            .map { $0 == 204 }
    }
}
