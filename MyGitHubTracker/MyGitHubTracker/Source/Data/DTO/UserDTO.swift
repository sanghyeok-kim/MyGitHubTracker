//
//  UserDTO.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct UserDTO: Decodable {
    let login: String
    let avatarURL: String
    let url: String
    let name: String
    let followers: Int
    let following: Int

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case url
        case name
        case followers
        case following
    }
}
