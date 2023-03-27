//
//  DefaultAccountUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultAccountUseCase: AccountUseCase {
    
    @Inject private var accountRepository: AccountRepository
    @Inject private var userTransformer: AnyTransformer<UserDTO, UserEntity>
    
    func fetchUserInfo() -> Single<UserEntity> {
        return accountRepository.fetchUserInfo()
            .decodeMap(UserDTO.self)
            .transformMap(userTransformer)
    }
}

