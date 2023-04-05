//
//  DefaultRepoListCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import UIKit

final class DefaultRepoListCoordinator: Coordinator, RepoListCoordinator {
    
    var childCoordinatorMap: [CoordinatorType : Coordinator] = [:]
    var navigationController: UINavigationController
    var type: CoordinatorType = .repoList
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRepoListViewController()
    }
    
    func coordinate(by action: RepoListCoordinateAction) {
        switch action {
        case .cellDidTap(let viewModel):
            pushRepositoryDetailViewController(with: viewModel)
        }
    }
    
    deinit {
        CustomLogger.log(message: "\(self) deallocated", category: .allocation, type: .info)
    }
}

// MARK: - Coordinating Methods

private extension DefaultRepoListCoordinator {
    func showRepoListViewController() {
        let repoListViewController = RepoListViewController()
        repoListViewController.bind(viewModel: RepoListViewModel(coordinator: self))
        navigationController.setViewControllers([repoListViewController], animated: false)
    }
    
    func pushRepositoryDetailViewController(with viewModel: RepositoryDetailViewModel) {
        let repositoryDetailViewController = RepositoryDetailViewController()
        repositoryDetailViewController.bind(viewModel: viewModel)
        navigationController.pushViewController(repositoryDetailViewController, animated: true)
    }
}
