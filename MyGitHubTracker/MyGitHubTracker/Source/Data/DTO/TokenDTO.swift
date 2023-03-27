//
//  TokenDTO.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct TokenDTO: Decodable {
    let accessToken: String
    let scope: String
    let tokenType: String
    
    enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
     }
}
