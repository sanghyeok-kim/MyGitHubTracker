//
//  DefaultRepositoryListUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultRepositoryListUseCase: RepositoryListUseCase {
    
    @Inject private var repositorySearchRepository: RepositorySearchRepository
    @Inject private var starringRepository: StarringRepository
    
    func fetchUserRepositories(perPage: Int, page: Int) -> Observable<[RepositoryEntity]> {
        return repositorySearchRepository
            .fetchUserRepositories(perPage: perPage, page: page)
            .asObservable()
            .withUnretained(self)
            .flatMap { `self`, repositoryEntities -> Observable<([RepositoryEntity], [Bool])> in
                self.zipIsStarredByUser(with: repositoryEntities)
            }
            .withUnretained(self)
            .map { `self`, result -> [RepositoryEntity] in
                let (repositoryEntities, isStarredByUsers) = result
                return self.updateIsStarredByUser(of: repositoryEntities, bools: isStarredByUsers)
            }
    }
}

// MARK: - Supporting Methods

private extension DefaultRepositoryListUseCase {
    private func zipIsStarredByUser(with repositories: [RepositoryEntity]) -> Observable<([RepositoryEntity], [Bool])> {
        let isStarredObservables = repositories.map {
            starringRepository
                .checkRepositoryIsStarred(ownerName: $0.ownerName, repositoryName: $0.name)
                .asObservable()
        }
        return Observable.zip(Observable.just(repositories), Observable.combineLatest(isStarredObservables))
    }
    
    private func updateIsStarredByUser(of repositories: [RepositoryEntity], bools: [Bool]) -> [RepositoryEntity] {
        return repositories.enumerated().map { index, repository -> RepositoryEntity in
            var updatedRepository = repository
            updatedRepository.isStarredByUser = bools[index]
            return updatedRepository
        }
    }
}
