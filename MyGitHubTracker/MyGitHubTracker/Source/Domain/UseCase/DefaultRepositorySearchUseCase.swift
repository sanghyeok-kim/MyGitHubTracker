//
//  DefaultRepositorySearchUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class DefaultRepositorySearchUseCase: RepositorySearchUseCase {
    
    @Inject private var repositorySearchRepository: RepositorySearchRepository
    
    func fetchUserRepositories(perPage: Int, page: Int) -> Observable<[RepositoryEntity]> {
        return repositorySearchRepository
            .fetchUserRepositories(perPage: perPage, page: page)
            .asObservable()
    }
    
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) -> Observable<RepositoryEntity> {
        return repositorySearchRepository
            .fetchRepositoryDetail(ownerName: ownerName, repositoryName: repositoryName)
            .asObservable()
    }
}
