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
    
    // Repository
    case fetchUserRepositories(perPage: Int, page: Int)
    case fetchRepositoryDetail(ownerName: String, repositoryName: String)
    case checkRepositoryIsStarredByUser(ownerName: String, repositoryName: String)
    
    // Account
    case fetchUserInfo
}

extension GitHubAPI: TargetType {
    var baseURL: URL? {
        switch self {
        case .fetchTempCode, .fetchAccessToken:
            return URL(string: "https://github.com")
        case .fetchUserRepositories, .fetchUserInfo, .fetchRepositoryDetail, .checkRepositoryIsStarredByUser:
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
        case .fetchUserRepositories:
            return "/user/repos"
        case .fetchRepositoryDetail(let ownerName, let repositoryName):
            return "/repos/\(ownerName)/\(repositoryName)"
        case .checkRepositoryIsStarredByUser(let ownerName, let repositoryName):
            return "user/starred/\(ownerName)/\(repositoryName)"
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
        case .fetchUserRepositories:
            return .get
        case .fetchRepositoryDetail:
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
        case .fetchUserInfo, .fetchUserRepositories, .fetchRepositoryDetail, .checkRepositoryIsStarredByUser:
            return ["Accept": "application/vnd.github+json",
                    "Authorization": "Bearer \(TokenStorage.shared.accessToken ?? "")",
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
        case .fetchUserRepositories(let perPage, let page):
            return ["sort": "created",
                    "type": "owner",
                    "per_page": perPage,
                    "page": page]
        case .fetchRepositoryDetail, .checkRepositoryIsStarredByUser:
            return nil
        }
    }
}
