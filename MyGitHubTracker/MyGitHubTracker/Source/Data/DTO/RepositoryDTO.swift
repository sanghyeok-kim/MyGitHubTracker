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
    let description: String?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case `private`
        case description
        case updatedAt = "updated_at"
    }
}
