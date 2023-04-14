//
//  RepositoryUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

protocol RepositoryUseCase {
    func toggleStarCount(of repository: RepositoryEntity) -> RepositoryEntity
    func toggleIsStarredByUser(of repository: RepositoryEntity, isStarred: Bool) -> RepositoryEntity
    func changeStargazersCount(of repository: RepositoryEntity, count: Int) -> RepositoryEntity
}
