//
//  AppCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

protocol AppCoordinator: Coordinator {
    func coordinate(by action: AppCoordinateAction)
}
