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
    
    private lazy var repoListViewController: RepoListViewController = {
        let repoListViewController = RepoListViewController()
        repoListViewController.bind(viewModel: RepoListViewModel(coordinator: self))
        return repoListViewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRepoListViewController()
    }
    
    func coordinate(by action: RepoListCoordinateAction) {
        
    }
    
    deinit {
        CustomLogger.log(message: "\(self) deallocated", category: .allocation, type: .info)
    }
}

// MARK: - Scene Changing Methods

private extension DefaultRepoListCoordinator {
    func showRepoListViewController() {
        navigationController.setViewControllers([repoListViewController], animated: false)
    }
}
