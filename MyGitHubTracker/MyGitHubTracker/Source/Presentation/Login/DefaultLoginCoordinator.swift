//
//  DefaultLoginCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/31.
//

import UIKit

final class DefaultLoginCoordinator: LoginCoordinator {
    
    var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    var navigationController: UINavigationController
    let type: CoordinatorType = .login
    weak var flowCompletionDelegate: LoginCoordinatorCompletionDelegate?
    
    init(navigationController: UINavigationController, finishDelegate: LoginCoordinatorCompletionDelegate) {
        self.navigationController = navigationController
        self.flowCompletionDelegate = finishDelegate
    }
    
    func start() {
        showLoginViewController()
    }
    
    func coordinate(by action: LoginCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch action {
            case .loginButtonDidTap(let url):
                self?.open(url: url)
            case .userDidAuthorize(let url):
                self?.handleUserAuthorization(with: url)
            case .accessTokenDidfetch:
                self?.flowCompletionDelegate?.showNextFlow()
            }
        }
    }
    
    deinit {
        CustomLogger.log(message: "\(self) deallocated", category: .allocation, type: .info)
    }
}

// MARK: - Coordinating Methods

private extension DefaultLoginCoordinator {
    func showLoginViewController() {
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel(coordinator: self)
        loginViewController.bind(viewModel: loginViewModel)
        navigationController.setViewControllers([loginViewController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func open(url: URL) {
        UIApplication.shared.open(url)
    }
}

// MARK: - Supporting Methods

private extension DefaultLoginCoordinator {
    func handleUserAuthorization(with callBackURL: URL) {
        let loginViewController = navigationController.visibleViewController as? LoginViewController
        loginViewController?.viewModel?.userDidAuthorize(callBack: callBackURL)
    }
}
