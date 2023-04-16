//
//  DefaultRepositoryDetailUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import RxSwift

final class DefaultRepositoryDetailUseCase: RepositoryDetailUseCase {

    @Inject private var repositorySearchRepository: RepositorySearchRepository
    
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) -> Observable<RepositoryEntity> {
        return repositorySearchRepository
            .fetchRepositoryDetail(ownerName: ownerName, repositoryName: repositoryName)
            .asObservable()
    }
}
