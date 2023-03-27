//
//  Container.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

final class Container {
    
    static let shared = Container()
    private var storage: [String: Any] = [:]
    
    private init() { }
    
    func register<T>(service: T.Type, _ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        storage[key] = factory
    }
    
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let factory = storage[key] as? () -> T else {
            fatalError("Dependency \(T.self) not resolved.")
        }
        return factory()
    }
}

extension Container {
    func registerDependencies() {
        // Service
        Container.shared.register(service: URLSessionNetworkService.self) { DefaultURLSessionService.shared }
        Container.shared.register(service: GitHubAuthorizationService.self) { DefaultGitHubAuthorizationService() }
        
        // Login
        Container.shared.register(service: LoginRepository.self) { DefaultLoginRepository() }
        Container.shared.register(service: LoginUseCase.self) { DefaultLoginUseCase() }
    }
}