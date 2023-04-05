//
//  RepositoryTransformer.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct RepositoryTransformer: Transformable {
    func transform(_ repositoryDTO: RepositoryDTO) -> RepositoryEntity {
        return RepositoryEntity(
            name: repositoryDTO.name,
            isPrivate: repositoryDTO.private,
            ownerName: repositoryDTO.owner.login,
            description: repositoryDTO.description,
            updatedDate: repositoryDTO.updatedAt.toDateFormat ?? "",
            stargazersCount: repositoryDTO.stargazersCount
        )
    }
}
