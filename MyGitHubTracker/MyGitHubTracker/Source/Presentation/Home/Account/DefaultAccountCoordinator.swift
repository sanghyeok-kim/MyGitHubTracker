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
    
    private lazy var accountViewController: AccountViewController = {
        let accountViewController = AccountViewController()
        accountViewController.bind(viewModel: AccountViewModel(coordinator: self))
        return accountViewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAccountViewController()
    }
    
    func coordinate(by action: AccountCoordinateAction) {
        
    }
    
    deinit {
        CustomLogger.logDeallocation(object: self)
    }
}


// MARK: - Scene Changing Methods

private extension DefaultAccountCoordinator {
    func showAccountViewController() {
        navigationController.setViewControllers([accountViewController], animated: false)
    }
}
