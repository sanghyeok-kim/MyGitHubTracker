//
//  RepositoryEntity.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct RepositoryEntity {
    let name: String
    let isPrivate: Bool
    let ownerName: String
    let description: String?
    let updatedDate: String
    var isStarredByUser: Bool = false
    var stargazersCount: Int
    let avatarImageURL: URL?
}
