//
//  RepositoryDTO.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct RepositoryDTO: Decodable {
    let name: String
    let `private`: Bool
    let owner: OwnerDTO
    let description: String?
    let updatedAt: String
    let stargazersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case `private`
        case owner
        case description
        case updatedAt = "updated_at"
        case stargazersCount = "stargazers_count"
    }
}

extension RepositoryDTO {
    struct OwnerDTO: Decodable {
        let login: String
    }
}
