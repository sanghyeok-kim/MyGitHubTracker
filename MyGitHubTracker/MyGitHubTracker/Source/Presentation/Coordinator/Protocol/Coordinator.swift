//
//  Coordinator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinatorMap: [CoordinatorType: Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var `type`: CoordinatorType { get }
    
    func start()
}

extension Coordinator {
    func add(childCoordinator: Coordinator) {
        childCoordinatorMap[childCoordinator.type] = childCoordinator
    }
    
    func delete(childCoordinator type: CoordinatorType) {
        childCoordinatorMap.removeValue(forKey: type)
    }
}