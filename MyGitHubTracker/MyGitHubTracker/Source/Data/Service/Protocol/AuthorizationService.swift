//
//  AuthorizationService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/05.
//

import Foundation

protocol AuthorizationService {
    func buildAuthorizationURL() -> URL?
}
