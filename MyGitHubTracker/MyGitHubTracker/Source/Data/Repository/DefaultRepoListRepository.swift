//
//  DefaultRepoListRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultRepoListRepository: RepoListRepository {
    
    @Inject private var urlSessionNetworkService: URLSessionNetworkService
    
    func fetchRepositories(perPage: Int, page: Int) -> Single<[RepositoryDTO]> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchRepositories(perPage: perPage, page: page))
            .decodeMap([RepositoryDTO].self)
    }
}
