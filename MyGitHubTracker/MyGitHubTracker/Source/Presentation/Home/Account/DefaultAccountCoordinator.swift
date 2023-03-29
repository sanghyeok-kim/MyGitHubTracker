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
    #if DEBUG
        CustomLogger.log(message: "\(self) deallocated", category: .allocation, type: .info)
    #endif
    }
}


// MARK: - Scene Changing Methods

private extension DefaultAccountCoordinator {
    func showAccountViewController() {
        navigationController.setViewControllers([accountViewController], animated: false)
    }
}
