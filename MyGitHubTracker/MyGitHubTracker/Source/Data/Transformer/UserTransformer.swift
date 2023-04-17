//
//  UserTransformer.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct UserTransformer: Transformable {
    func transform(_ userDTO: UserDTO) -> UserEntity {
        return UserEntity(
            loginID: userDTO.login,
            avatarImageURL: URL(string: userDTO.avatarURL),
            gitHubURL: URL(string: userDTO.url),
            name: userDTO.name,
            followersCount: userDTO.followers,
            followingCount: userDTO.following
        )
    }
}
