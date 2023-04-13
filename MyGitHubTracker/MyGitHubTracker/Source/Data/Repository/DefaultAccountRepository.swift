//
//  DefaultAccountRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultAccountRepository: AccountRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    @Inject private var userTransformer: AnyTransformer<UserDTO, UserEntity>
    
    func fetchUserInfo() -> Single<UserEntity> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchUserInfo)
            .decodeMap(UserDTO.self)
            .transformMap(userTransformer)
    }
}
