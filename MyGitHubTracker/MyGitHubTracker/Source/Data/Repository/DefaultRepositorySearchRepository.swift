//
//  DefaultRepositorySearchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultRepositorySearchRepository: RepositorySearchRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    @Inject private var repositoryDataMapper: AnyDataMapper<RepositoryDTO, RepositoryEntity>
    
    func fetchUserRepositories(perPage: Int, page: Int) -> Single<[RepositoryEntity]> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchUserRepositories(perPage: perPage, page: page))
            .decodeMap([RepositoryDTO].self)
            .transformMap(repositoryDataMapper)
    }
    
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) -> Single<RepositoryEntity> {
        urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchRepositoryDetail(ownerName: ownerName, repositoryName: repositoryName))
            .decodeMap(RepositoryDTO.self)
            .transformMap(repositoryDataMapper)
    }
}
