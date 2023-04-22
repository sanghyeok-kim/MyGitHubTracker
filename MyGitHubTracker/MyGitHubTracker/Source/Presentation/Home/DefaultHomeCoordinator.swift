//
//  DefaultHomeCoordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import UIKit

final class DefaultHomeCoordinator: Coordinator {
    
    var childCoordinatorMap: [CoordinatorType : Coordinator] = [:]
    var navigationController: UINavigationController
    var type: CoordinatorType = .home
    
    private lazy var repositoryListCoordinator: RepositoryListCoordinator = {
        let rootNavigationController = UINavigationController()
        let coordinator = DefaultRepositoryListCoordinator(navigationController: rootNavigationController)
        rootNavigationController.tabBarItem = UITabBarItem(
            title: Constant.Text.repository,
            image: UIImage(systemName: Constant.Image.listBulletRectanglePortrait),
            tag: 0
        )
        return coordinator
    }()
    
    private lazy var accountCoordinator: AccountCoordinator = {
        let rootNavigationController = UINavigationController()
        let coordinator = DefaultAccountCoordinator(navigationController: rootNavigationController)
        rootNavigationController.tabBarItem = UITabBarItem(
            title: Constant.Text.account,
            image: UIImage(systemName: Constant.Image.person),
            tag: 1
        )
        return coordinator
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeTabBarController = UITabBarController()
        homeTabBarController.viewControllers = [
            repositoryListCoordinator.navigationController,
            accountCoordinator.navigationController
        ]
        add(childCoordinator: repositoryListCoordinator)
        add(childCoordinator: accountCoordinator)
        repositoryListCoordinator.start()
        accountCoordinator.start()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([homeTabBarController], animated: true)
    }
    
    deinit {
        CustomLogger.logDeallocation(object: self)
    }
}

