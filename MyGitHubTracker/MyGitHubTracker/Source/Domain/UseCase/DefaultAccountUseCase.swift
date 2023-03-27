//
//  DefaultAccountUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultAccountUseCase: AccountUseCase {
    
    @Inject private var accountRepository: AccountRepository
    private let userTransformer = UserTransformer()
    
    func fetchUserInfo() -> Single<UserEntity> {
        return accountRepository.fetchUserInfo()
            .decodeMap(UserDTO.self)
            .transformMap(userTransformer)
    }
}

