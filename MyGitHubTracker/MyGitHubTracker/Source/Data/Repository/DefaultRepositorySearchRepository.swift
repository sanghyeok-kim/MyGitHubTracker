//
//  DefaultRepositorySearchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultRepositorySearchRepository: RepositorySearchRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    
    func fetchUserRepositories(perPage: Int, page: Int) -> Single<[RepositoryDTO]> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchUserRepositories(perPage: perPage, page: page))
            .decodeMap([RepositoryDTO].self)
    }
    
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) -> Single<RepositoryDTO> {
        urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchRepositoryDetail(ownerName: ownerName, repositoryName: repositoryName))
            .decodeMap(RepositoryDTO.self)
    }
}
