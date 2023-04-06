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
        Container.shared.register(service: MemoryCachable.self) { MemoryCache.shared }
        Container.shared.register(service: DiskCachable.self) { DiskCache.shared }
        
        
        // Service
        Container.shared.register(service: URLSessionNetworkService.self) { DefaultURLSessionService.shared }
        Container.shared.register(service: GitHubAuthorizationService.self) { DefaultGitHubAuthorizationService() }
        Container.shared.register(service: ImageFetchService.self) { URLSessionImageFetchService() }
        
        // Login
        Container.shared.register(service: LoginRepository.self) { DefaultLoginRepository() }
        Container.shared.register(service: LoginUseCase.self) { DefaultLoginUseCase() }
        
        // RepositoryList
        Container.shared.register(service: RepositorySearchRepository.self) { DefaultRepositorySearchRepository() }
        Container.shared.register(service: RepositorySearchUseCase.self) { DefaultRepositorySearchUseCase() }
        Container.shared.register(service: AnyTransformer.self) { AnyTransformer(RepositoryTransformer()) }
        
        //Starring
        Container.shared.register(service: StarringRepository.self) { DefaultStarringRepository() }
        Container.shared.register(service: StarringUseCase.self) { DefaultStarringUseCase() }
        
        // Account
        Container.shared.register(service: AccountUseCase.self) { DefaultAccountUseCase() }
        Container.shared.register(service: AccountRepository.self) { DefaultAccountRepository() }
        Container.shared.register(service: AnyTransformer.self) { AnyTransformer(UserTransformer()) }
    }
}
