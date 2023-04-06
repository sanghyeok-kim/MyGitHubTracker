//
//  DefaultAccountRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultAccountRepository: AccountRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    
    func fetchUserInfo() -> Single<UserDTO> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchUserInfo)
            .decodeMap(UserDTO.self)
    }
}
