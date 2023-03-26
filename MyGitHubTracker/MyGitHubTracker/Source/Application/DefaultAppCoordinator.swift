//
//  DefaultAppCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import UIKit

final class DefaultAppCoordinator: AppCoordinator {
    
    var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    var navigationController: UINavigationController
    let type: CoordinatorType = .app
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        switch AccessToken.isStored() {
        case true:
            coordinate(by: .accessTokenDidfetch)
        case false:
            coordinate(by: .appDidStart)
        }
    }
    
    func coordinate(by action: AppCoordinateAction) {
        
    }
}

// MARK: - Scene Changing Methods

private extension DefaultAppCoordinator {
    func showLoginViewController() {
        
    }
    
    func showHomeCoordinatorFlow() {
        
    }
    
    func open(url: URL) {
        UIApplication.shared.open(url)
    }
}
