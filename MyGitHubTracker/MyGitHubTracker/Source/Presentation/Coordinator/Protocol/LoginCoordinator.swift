//
//  LoginCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/31.
//

import Foundation

protocol LoginCoordinator: Coordinator {
    func coordinate(by action: LoginCoordinateAction)
    var finishDelegate: LoginCoordinatorFinishDelegate? { get }
}
