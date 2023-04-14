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
        Container.shared.register(service: EndpointService.self) { URLSessionEndpointService.shared }
        Container.shared.register(service: AuthorizationService.self) { GitHubAuthorizationService() }
        Container.shared.register(service: URLDataService.self) { URLSessionURLDataService.shared }
        
        // Token Storage
        Container.shared.register(service: TokenStorable.self) { TokenStorage.shared }
        Container.shared.register(service: TokenRepository.self) { DefaultTokenRepository() }
        
        // Cache Storage
        Container.shared.register(service: MemoryCachable.self) { MemoryCache.shared }
        Container.shared.register(service: DiskCachable.self) { DiskCache.shared }
        
        // Cached Data
        Container.shared.register(service: ImageLoader.self) { CachedImageLoader() }
        Container.shared.register(service: URLDataFetchRepository.self) { CachedURLDataFetchRepository() }
        
        // Login
        Container.shared.register(service: LoginRepository.self) { DefaultLoginRepository() }
        Container.shared.register(service: LoginUseCase.self) { DefaultLoginUseCase() }
        
        // RepositoryList
        Container.shared.register(service: RepositorySearchRepository.self) { DefaultRepositorySearchRepository() }
        Container.shared.register(service: RepositorySearchUseCase.self) { DefaultRepositorySearchUseCase() }
        Container.shared.register(service: PaginationUseCase.self) { DefaultPaginationUseCase() }
        Container.shared.register(service: AnyTransformer.self) { AnyTransformer(RepositoryTransformer()) }
        
        //Starring
        Container.shared.register(service: StarringRepository.self) { DefaultStarringRepository() }
        Container.shared.register(service: StarringUseCase.self) { DefaultStarringUseCase() }
        
        // RepositoryDetail
        Container.shared.register(service: RepositoryUseCase.self) { DefaultRepositoryUseCase() }
        
        // Account
        Container.shared.register(service: AccountUseCase.self) { DefaultAccountUseCase() }
        Container.shared.register(service: AccountRepository.self) { DefaultAccountRepository() }
        Container.shared.register(service: AnyTransformer.self) { AnyTransformer(UserTransformer()) }
    }
}
