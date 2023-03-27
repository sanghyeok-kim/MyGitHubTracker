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
    
    private lazy var loginViewController: LoginViewController = {
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel(coordinator: self)
        loginViewController.bind(viewModel: loginViewModel)
        return loginViewController
    }()
    
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
        DispatchQueue.main.async { [weak self] in
            switch action {
            case .appDidStart:
                self?.showLoginViewController()
            case .loginButtonDidTap(let url):
                self?.open(url: url)
            case .userDidAuthorize(let url):
                self?.loginViewController.viewModel?.userDidAuthorize(callBack: url)
            case .accessTokenDidfetch:
                self?.showHomeCoordinatorFlow()
            }
        }
    }
}

// MARK: - Scene Changing Methods

private extension DefaultAppCoordinator {
    func showLoginViewController() {
        navigationController.setViewControllers([loginViewController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func showHomeCoordinatorFlow() {
        
    }
    
    func open(url: URL) {
        UIApplication.shared.open(url)
    }
}
