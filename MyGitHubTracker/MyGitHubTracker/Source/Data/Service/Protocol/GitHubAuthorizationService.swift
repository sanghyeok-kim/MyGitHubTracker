//
//  GitHubAuthorizationService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/05.
//

import Foundation

protocol GitHubAuthorizationService {
    func buildGitHubAuthorizationURL() -> URL?
}
