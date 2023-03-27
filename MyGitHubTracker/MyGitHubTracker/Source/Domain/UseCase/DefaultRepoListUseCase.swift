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
            .map { data -> [RepositoryDTO] in
                guard let repositories = try? JSONDecoder().decode([RepositoryDTO].self, from: data) else {
                    throw NetworkError.decodeError
                }
                
                return repositories
            }
            .map { $0.map { self.repoListTransformer.transform($0) } }
    }
    
}
