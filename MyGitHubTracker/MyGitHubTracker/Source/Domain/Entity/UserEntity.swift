//
//  UserEntity.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct UserEntity {
    let loginID: String
    let avatarImageURL: URL?
    let gitHubURL: URL?
    let name: String
    let followersCount: Int
    let followingCount: Int
}
