//
//  DefaultStarringRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift

final class DefaultStarringRepository: StarringRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    @Inject private var repositoryDataMapper: AnyDataMapper<RepositoryDTO, RepositoryEntity>
    
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
    
    func fetchUserStarredRepositories(perPage: Int, page: Int) -> Single<[RepositoryEntity]> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchUserStarredRepositories(perPage: perPage, page: page))
            .decodeMap([RepositoryDTO].self)
            .transformMap(repositoryDataMapper)
    }
}
