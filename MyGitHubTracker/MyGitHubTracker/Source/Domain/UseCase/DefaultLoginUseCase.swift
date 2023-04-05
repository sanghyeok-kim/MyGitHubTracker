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
    
    @Inject private var loginRepository: LoginRepository
    private let disposeBag = DisposeBag()
    
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
            .do(onSuccess: { tokenDTO in
                AccessToken.store(value: tokenDTO.accessToken)
            }, onError: { error in
                CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
            })
            .subscribe(with: self, onSuccess: { `self`, _ in
                self.userDidAuthorized.accept(())
            }, onFailure: { `self`, error in
                self.errorDidOccur.accept(.failToFetchAccessToken)
            })
            .disposed(by: disposeBag)
    }
}
