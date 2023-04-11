//
//  DefaultLoginUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultLoginUseCase: LoginUseCase {
    
    @Inject private var loginRepository: LoginRepository
    
    func buildGitHubAuthorizationURL() -> URL? {
        return loginRepository.buildGitHubAuthorizationURL()
    }
    
    func fetchAndStoreAccessToken(with url: URL) -> Completable {
        let gitHubAuthorization = GitHubAuthorizationEntity(url: url)
        
        return loginRepository
            .fetchAccessToken(
                clientID: gitHubAuthorization.clientID,
                clientSecret: gitHubAuthorization.clientSecret,
                tempCode: gitHubAuthorization.tempCode
            )
            .do(onSuccess: {
                AccessToken.store(value: $0)
            })
            .asCompletable()
    }
}
