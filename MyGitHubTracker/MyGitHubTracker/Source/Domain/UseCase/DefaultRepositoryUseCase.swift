//
//  DefaultRepositoryUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

final class DefaultRepositoryUseCase: RepositoryUseCase {
    func toggleStarCount(of repository: RepositoryEntity) -> RepositoryEntity {
        var newRepository = repository
        let (isStarred, starCount) = (repository.isStarredByUser, repository.stargazersCount)
        let newStarCount = isStarred ? starCount - 1 : starCount + 1
        newRepository.stargazersCount = newStarCount
        return newRepository
    }
    
    func toggleIsStarredByUser(of repository: RepositoryEntity, isStarred: Bool) -> RepositoryEntity {
        var newRepository = repository
        newRepository.isStarredByUser = isStarred
        return newRepository
    }
    
    func changeStargazersCount(of repository: RepositoryEntity, count: Int) -> RepositoryEntity {
        var newRepository = repository
        newRepository.stargazersCount = count
        return newRepository
    }
}
