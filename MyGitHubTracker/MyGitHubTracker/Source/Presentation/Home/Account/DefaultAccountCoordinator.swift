//
//  DefaultAccountCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import UIKit

final class DefaultAccountCoordinator: AccountCoordinator {
    
    var childCoordinatorMap: [CoordinatorType : Coordinator] = [:]
    var navigationController: UINavigationController
    var type: CoordinatorType = .account
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAccountViewController()
    }
    
    func coordinate(by action: AccountCoordinateAction) {
        DispatchQueue.main.async { [weak self] in
            switch action {
            case .showAllButtonDidTap:
                self?.pushStarredRepositoryListViewController()
            }
        }
    }
    
    deinit {
        CustomLogger.logDeallocation(object: self)
    }
}

// MARK: - Coordinating Methods

private extension DefaultAccountCoordinator {
    func showAccountViewController() {
        let accountViewController = AccountViewController()
        accountViewController.bind(viewModel: AccountViewModel(coordinator: self))
        navigationController.setViewControllers([accountViewController], animated: false)
    }
    
    func pushStarredRepositoryListViewController() {
        let viewController = StarredRepositoryListViewController()
        viewController.bind(viewModel: StarredRepositoryListViewModel(coordinator: self))
        navigationController.pushViewController(viewController, animated: true)
    }
}
