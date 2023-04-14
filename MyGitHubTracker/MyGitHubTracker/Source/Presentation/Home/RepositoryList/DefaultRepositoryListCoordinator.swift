//
//  DefaultRepositoryListCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import UIKit

final class DefaultRepositoryListCoordinator: Coordinator, RepositoryListCoordinator {
    
    var childCoordinatorMap: [CoordinatorType : Coordinator] = [:]
    var navigationController: UINavigationController
    var type: CoordinatorType = .repositoryList
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRepositoryListViewController()
    }
    
    func coordinate(by action: RepositoryListCoordinateAction) {
        switch action {
        case .cellDidTap(let viewModel):
            pushRepositoryDetailViewController(with: viewModel)
        }
    }
    
    deinit {
        CustomLogger.logDeallocation(object: self)
    }
}

// MARK: - Coordinating Methods

private extension DefaultRepositoryListCoordinator {
    func showRepositoryListViewController() {
        let repositoryListViewController = RepositoryListViewController()
        repositoryListViewController.bind(viewModel: RepositoryListViewModel(coordinator: self))
        navigationController.setViewControllers([repositoryListViewController], animated: false)
    }
    
    func pushRepositoryDetailViewController(with viewModel: RepositoryDetailViewModel) {
        let repositoryDetailViewController = RepositoryDetailViewController()
        repositoryDetailViewController.bind(viewModel: viewModel)
        navigationController.pushViewController(repositoryDetailViewController, animated: true)
    }
}
