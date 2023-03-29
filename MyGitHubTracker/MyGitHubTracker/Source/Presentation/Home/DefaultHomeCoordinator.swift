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
    
    private lazy var repoListCoordinator: RepoListCoordinator = {
        let rootNavigationController = UINavigationController()
        let coordinator = DefaultRepoListCoordinator(navigationController: rootNavigationController)
        rootNavigationController.tabBarItem = UITabBarItem(
            title: "Repository",
            image: UIImage(systemName: "list.bullet.rectangle.portrait"),
            tag: 0
        )
        return coordinator
    }()
    
    private lazy var accountCoordinator: AccountCoordinator = {
        let rootNavigationController = UINavigationController()
        let coordinator = DefaultAccountCoordinator(navigationController: rootNavigationController)
        rootNavigationController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person"),
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
            repoListCoordinator.navigationController,
            accountCoordinator.navigationController
        ]
        add(childCoordinator: repoListCoordinator)
        add(childCoordinator: accountCoordinator)
        repoListCoordinator.start()
        accountCoordinator.start()
        navigationController.pushViewController(homeTabBarController, animated: true)
    }
    
    deinit {
    #if DEBUG
        CustomLogger.log(message: "\(self) deallocated", category: .allocation, type: .info)
    #endif
    }
}

