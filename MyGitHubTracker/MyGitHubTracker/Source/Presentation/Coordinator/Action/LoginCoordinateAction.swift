//
//  LoginCoordinateAction.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/31.
//

import Foundation

enum LoginCoordinateAction {
    case loginButtonDidTap(url: URL)
    case userDidAuthorize(url: URL)
    case accessTokenDidfetch
}
