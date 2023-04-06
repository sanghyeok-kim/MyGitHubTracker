//
//  DefaultRepositorySearchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultRepositorySearchRepository: RepositorySearchRepository {
    
    @Inject private var urlSessionNetworkService: URLSessionNetworkService
    
    func fetchUserRepositories(perPage: Int, page: Int) -> Single<[RepositoryDTO]> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchUserRepositories(perPage: perPage, page: page))
            .decodeMap([RepositoryDTO].self)
    }
}