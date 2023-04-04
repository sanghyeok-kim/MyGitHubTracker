//
//  GitHubAPI.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

enum GitHubAPI {
    // Login
    case fetchTempCode
    case fetchAccessToken(clientID: String, clientSecret: String, tempCode: String)
    
    // RepoList
    case fetchRepositories(perPage: Int, page: Int)
    
    // Account
    case fetchUserInfo
    case checkRepositoryIsStarredByUser(repositoryOwner: String, repositoryName: String)
}

extension GitHubAPI: TargetType {
    var baseURL: URL? {
        switch self {
        case .fetchTempCode, .fetchAccessToken:
            return URL(string: "https://github.com")
        case .fetchRepositories, .fetchUserInfo, .checkRepositoryIsStarredByUser:
            return URL(string: "https://api.github.com")
        }
    }
    
    var path: String {
        switch self {
        case .fetchTempCode:
            return "/login/oauth/authorize"
        case .fetchAccessToken:
            return "/login/oauth/access_token"
        case .fetchUserInfo:
            return "/user"
        case .fetchRepositories:
            return "/user/repos"
        case .checkRepositoryIsStarredByUser(let repositoryOwner, let repositoryName):
            return "user/starred/\(repositoryOwner)/\(repositoryName)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTempCode:
            return .get
        case .fetchAccessToken:
            return .post
        case .fetchUserInfo:
            return .get
        case .fetchRepositories:
            return .get
        case .checkRepositoryIsStarredByUser:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchTempCode:
            return nil
        case .fetchAccessToken:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        case .fetchUserInfo, .fetchRepositories, .checkRepositoryIsStarredByUser:
            return ["Accept": "application/vnd.github+json",
                    "Authorization": "Bearer \(AccessToken.value ?? "")",
                    "X-GitHub-Api-Version": "2022-11-28"]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchTempCode:
            return ["client_id": Constant.GitHubClientKey.clientID,
                    "scope": "repo, user"]
        case .fetchAccessToken(let clientID, let clientSecret, let tempCode):
            return ["scope": "repo, user",
                    "client_id": clientID,
                    "client_secret": clientSecret,
                    "code": tempCode]
        case .fetchUserInfo:
            return nil
        case .fetchRepositories(let perPage, let page):
            return ["sort": "created",
                    "type": "owner",
                    "per_page": perPage,
                    "page": page]
        case .checkRepositoryIsStarredByUser:
            return nil
        }
    }
}
