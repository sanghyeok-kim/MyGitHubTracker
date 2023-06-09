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
    
    // RepositoryCreation
    case createRepository
    
    // Account
    case fetchUserInfo
    
    // Starring
    case checkRepositoryIsStarredByUser(ownerName: String, repositoryName: String)
    case starRepository(ownerName: String, repositoryName: String)
    case unstarRepository(ownerName: String, repositoryName: String)
    case fetchUserStarredRepositories(perPage: Int, page: Int)
}

extension GitHubAPI: TargetType {
    var baseURL: URL? {
        switch self {
        case .fetchTempCode, .fetchAccessToken:
            return URL(string: "https://github.com")
        case .fetchUserRepositories,
                .fetchUserInfo,
                .fetchRepositoryDetail,
                .createRepository,
                .checkRepositoryIsStarredByUser,
                .starRepository,
                .unstarRepository,
                .fetchUserStarredRepositories:
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
        case .fetchUserRepositories, .createRepository:
            return "/user/repos"
        case .fetchRepositoryDetail(let ownerName, let repositoryName):
            return "/repos/\(ownerName)/\(repositoryName)"
        case .checkRepositoryIsStarredByUser(let ownerName, let repositoryName),
                .starRepository(let ownerName, let repositoryName),
                .unstarRepository(let ownerName, let repositoryName):
            return "user/starred/\(ownerName)/\(repositoryName)"
        case .fetchUserStarredRepositories:
            return "user/starred"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTempCode,
                .fetchUserInfo,
                .fetchUserRepositories,
                .fetchRepositoryDetail,
                .checkRepositoryIsStarredByUser,
                .fetchUserStarredRepositories:
            return .get
        case .fetchAccessToken, .createRepository:
            return .post
        case .starRepository:
            return .put
        case .unstarRepository:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchTempCode:
            return nil
        case .fetchAccessToken:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        case .fetchUserInfo,
                .fetchUserRepositories,
                .fetchRepositoryDetail,
                .createRepository,
                .checkRepositoryIsStarredByUser,
                .starRepository,
                .unstarRepository,
                .fetchUserStarredRepositories:
            return ["Accept": "application/vnd.github+json",
                    "Authorization": "Bearer \(TokenStorage.shared.accessToken ?? "")",
                    "X-GitHub-Api-Version": "2022-11-28"]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchUserInfo,
                .fetchRepositoryDetail,
                .createRepository,
                .checkRepositoryIsStarredByUser,
                .starRepository,
                .unstarRepository:
            return nil
        case .fetchTempCode:
            return ["client_id": Constant.GitHubClientKey.clientID,
                    "scope": "repo, user"]
        case .fetchAccessToken(let clientID, let clientSecret, let tempCode):
            return ["scope": "repo, user",
                    "client_id": clientID,
                    "client_secret": clientSecret,
                    "code": tempCode]
        case .fetchUserRepositories(let perPage, let page):
            return ["sort": "created",
                    "type": "owner",
                    "per_page": perPage,
                    "page": page]
        case .fetchUserStarredRepositories(let perPage, let page):
            return ["sort": "updated",
                    "per_page": perPage,
                    "page": page]
        }
    }
}
