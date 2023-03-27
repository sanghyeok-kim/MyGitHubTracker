//
//  DefaultGitHubAuthorizationService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

protocol GitHubAuthorizationService {
    func buildGitHubAuthorizationURL() -> URL?
}

final class DefaultGitHubAuthorizationService: GitHubAuthorizationService {
    func buildGitHubAuthorizationURL() -> URL? {
        let target = GitHubAPI.fetchTempCode
        
        guard let url = target.baseURL?.appendingPathComponent(target.path) else { return nil }
        var urlComponents = URLComponents(string: url.absoluteString)
        
        if let parameters = target.parameters {
            urlComponents?.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        }
        
        return urlComponents?.url
    }
}
