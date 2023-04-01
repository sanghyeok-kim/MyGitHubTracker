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
            startHomeCoordinatorFlow()
        case false:
            startLoginCoordinatorFlow()
        }
    }
    
    func coordinate(by action: AppCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch action {
            case .userDidAuthorize(let url):
                self?.handleAuthorization(url: url)
            case .accessTokenDidfetch:
                self?.startHomeCoordinatorFlow()
            }
        }
    }
    
    deinit {
    #if DEBUG
        CustomLogger.log(message: "\(self) deallocated", category: .allocation, type: .info)
    #endif
    }
}

// MARK: - Coordinating Methods

private extension DefaultAppCoordinator {
    
    func startLoginCoordinatorFlow() {
        let loginCoordinator = DefaultLoginCoordinator(navigationController: navigationController, finishDelegate: self)
        add(childCoordinator: loginCoordinator)
        loginCoordinator.start()
    }
    
    func startHomeCoordinatorFlow() {
        let homeCoordinator = DefaultHomeCoordinator(navigationController: navigationController)
        add(childCoordinator: homeCoordinator)
        homeCoordinator.start()
    }
    
    func handleAuthorization(url: URL) {
        let loginCoordinator = childCoordinatorMap[.login] as? LoginCoordinator
        loginCoordinator?.coordinate(by: .userDidAuthorize(url: url))
    }
}

extension DefaultAppCoordinator: LoginCoordinatorCompletionDelegate {
    func showNextFlow() {
        remove(childCoordinator: .login)
        coordinate(by: .accessTokenDidfetch)
    }
}
