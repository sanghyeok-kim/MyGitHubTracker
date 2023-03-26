//
//  AppCoordinateAction.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

enum AppCoordinateAction {
    case appDidStart
    case loginButtonDidTap(url: URL)
    case userDidAuthorize(url: URL)
    case accessTokenDidfetch
}
