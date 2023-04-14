//
//  RepositoryUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

protocol RepositoryUseCase {
    func toggleStargazersCount(_ repository: RepositoryEntity) -> RepositoryEntity
    func toggleIsStarredByUser(_ repository: RepositoryEntity) -> RepositoryEntity
    func changeIsStarredByUser(_ repository: RepositoryEntity, isStarred: Bool) -> RepositoryEntity
    func changeStargazersCount(_ repository: RepositoryEntity, count: Int) -> RepositoryEntity
}
