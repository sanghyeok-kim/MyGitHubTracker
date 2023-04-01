//
//  GitHubAuthorizationEntity.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/01.
//

import Foundation

struct GitHubAuthorizationEntity {
    let url: URL
    let clientID: String
    let clientSecret: String
    
    init(
        url: URL,
        clientID: String = Constant.GitHubClientKey.clientID,
        clientSecret: String = Constant.GitHubClientKey.clientSecret
    ) {
        self.url = url
        self.clientID = clientID
        self.clientSecret = clientSecret
    }

    var tempCode: String {
        return url.absoluteString.components(separatedBy: "code=").last ?? ""
    }
}
