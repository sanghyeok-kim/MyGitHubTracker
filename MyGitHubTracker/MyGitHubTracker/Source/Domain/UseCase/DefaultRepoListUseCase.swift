//
//  DefaultRepoListUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultRepoListUseCase: RepoListUseCase {
    
    @Inject private var repoListRepository: RepoListRepository
    private let repoListTransformer = RepositoryTransformer()
    
    func fetchRepositories(perPage: Int, page: Int) -> Single<[RepositoryEntity]> {
        return repoListRepository.fetchRepositories(perPage: perPage, page: page)
            .decodeMap([RepositoryDTO].self)
            .map { $0.map { self.repoListTransformer.transform($0) } }
    }
}
