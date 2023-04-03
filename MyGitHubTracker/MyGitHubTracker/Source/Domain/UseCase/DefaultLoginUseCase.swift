//
//  DefaultLoginUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class DefaultLoginUseCase: LoginUseCase {
    
    let errorDidOccur = PublishRelay<ToastError>()
    let userDidAuthorized = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    @Inject private var loginRepository: LoginRepository
    
    func buildGitHubAuthorizationURL() -> URL? {
        return loginRepository.buildGitHubAuthorizationURL()
    }
    
    func fetchAndStoreAccessToken(with url: URL) {
        let gitHubAuthorization = GitHubAuthorizationEntity(url: url)
        
        loginRepository
            .fetchAccessToken(
                clientID: gitHubAuthorization.clientID,
                clientSecret: gitHubAuthorization.clientSecret,
                tempCode: gitHubAuthorization.tempCode
            )
            .subscribe(with: self, onSuccess: { `self`, _ in
                self.userDidAuthorized.accept(())
            }, onFailure: { `self`, _ in
                self.errorDidOccur.accept(.failToFetchAccessToken)
            })
            .disposed(by: disposeBag)
    }
}
