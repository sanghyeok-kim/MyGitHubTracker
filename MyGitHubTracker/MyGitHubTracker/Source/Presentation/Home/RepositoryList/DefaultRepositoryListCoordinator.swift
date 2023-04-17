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
        DispatchQueue.main.async { [weak self] in
            switch action {
            case .cellDidTap(let viewModel):
                self?.pushRepositoryDetailViewController(with: viewModel)
            case .createRepositoryButtonDidTap(let viewModel):
                self?.presentRepositoryCreationViewController(with: viewModel)
            case .repositoryDidCreate:
                self?.dismissPresentedViewController()
            case .repositoryCreationDidCancel:
                self?.dismissPresentedViewController()
            }
        }
    }
    
    deinit {
        CustomLogger.logDeallocation(object: self)
    }
}

// MARK: - Coordinating Methods

private extension DefaultRepositoryListCoordinator {
    func showRepositoryListViewController() {
        let viewController = RepositoryListViewController()
        viewController.bind(viewModel: RepositoryListViewModel(coordinator: self))
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func pushRepositoryDetailViewController(with viewModel: RepositoryDetailViewModel) {
        let viewController = RepositoryDetailViewController()
        viewController.bind(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentRepositoryCreationViewController(with viewModel: RepositoryCreationViewModel) {
        let viewController = RepositoryCreationViewController()
        viewController.bind(viewModel: viewModel)
        let newNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(newNavigationController, animated: true)
    }
    
    func dismissPresentedViewController() {
        navigationController.dismiss(animated: true)
    }
}
