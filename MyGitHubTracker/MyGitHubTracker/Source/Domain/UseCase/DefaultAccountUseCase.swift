//
//  DefaultAccountUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultAccountUseCase: AccountUseCase {
    
    @Inject private var accountRepository: AccountRepository
    
    func fetchUserInfo() -> Observable<UserEntity> {
        return accountRepository
            .fetchUserInfo()
            .asObservable()
    }
}
