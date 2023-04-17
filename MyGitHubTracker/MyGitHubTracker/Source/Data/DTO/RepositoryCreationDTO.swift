//
//  RepositoryCreationDTO.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import Foundation

struct RepositoryCreationDTO: Encodable {
    let name: String
    let description: String?
    let `private`: Bool
}
