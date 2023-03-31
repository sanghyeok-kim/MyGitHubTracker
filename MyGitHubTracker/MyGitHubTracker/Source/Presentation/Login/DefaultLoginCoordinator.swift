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
    weak var finishDelegate: LoginCoordinatorFinishDelegate?
    
    init(navigationController: UINavigationController, finishDelegate: LoginCoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
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
                let loginViewController = self?.navigationController.visibleViewController as? LoginViewController
                loginViewController?.viewModel?.userDidAuthorize(callBack: url)
            case .accessTokenDidfetch:
                self?.finishDelegate?.showNextFlow()
            }
        }
    }
    
    deinit {
    #if DEBUG
        CustomLogger.log(message: "\(self) deallocated", category: .allocation, type: .info)
    #endif
    }
}

// MARK: - Scene Changing Methods

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
