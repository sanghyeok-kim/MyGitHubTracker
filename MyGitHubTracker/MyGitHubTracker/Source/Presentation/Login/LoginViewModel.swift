//
//  LoginViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class LoginViewModel: ViewModelType {
    
    struct Input {
        let gitHubLoginButtonDidTap = PublishRelay<Void>()
        let userDidAuthorize = PublishRelay<URL>()
    }
    
    struct Output {
        let showToastMessage = PublishRelay<String>()
    }
    
    let input = Input()
    let output = Output()
    
    @Inject private var loginUseCase: LoginUseCase
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - gitHubLoginButtonDidTap
        
        input.gitHubLoginButtonDidTap
            .withUnretained(self)
            .compactMap { `self`, _ in
                self.loginUseCase.buildGitHubAuthorizationURL()
            }
            .bind {
                coordinator?.coordinate(by: .loginButtonDidTap(url: $0))
            }
            .disposed(by: disposeBag)
        
        let accessTokenDidFetch = input.userDidAuthorize
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, url in
                self.loginUseCase.fetchAndStoreAccessToken(with: url)
            }
            .share()
        
        accessTokenDidFetch
            .compactMap { $0.element }
            .withUnretained(self)
            .bind { `self`, _ in
                self.coordinator?.coordinate(by: .accessTokenDidfetch)
            }
            .disposed(by: disposeBag)

        accessTokenDidFetch
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchAccessToken)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
    }
}

// MARK: - Public Methods

extension LoginViewModel {
    func userDidAuthorize(callBack url: URL) {
        input.userDidAuthorize.accept(url)
    }
}
