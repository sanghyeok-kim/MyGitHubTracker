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
        let showErrorMessage = PublishRelay<String>()
    }
    
    let input = Input()
    let output = Output()
    
    @Inject private var loginUseCase: LoginUseCase
    
    private weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        
        input.gitHubLoginButtonDidTap
            .withUnretained(self)
            .compactMap { `self`, _ in
                self.loginUseCase.buildGitHubAuthorizationURL()
            }
            .bind {
                coordinator.coordinate(by: .loginButtonDidTap(url: $0))
            }
            .disposed(by: disposeBag)
        
        let userDidAuthorize = input.userDidAuthorize
            .withUnretained(self)
            .flatMapLatest { `self`, url in
                self.loginUseCase.fetchAndStoreAccessToken(with: url)
            }
            .materialize()
            .share()
        
        userDidAuthorize
            .compactMap { $0.element }
            .bind { _ in
                coordinator.coordinate(by: .accessTokenDidfetch)
            }
            .disposed(by: disposeBag)
        
        userDidAuthorize
            .observe(on: MainScheduler.instance)
            .compactMap { $0.error }
            .logErrorAndMapToastMessage(to: .failToFetchAccessToken, logCategory: .network)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
    }
}

// MARK: - External Methods

extension LoginViewModel {
    func userDidAuthorize(callBack url: URL) {
        input.userDidAuthorize.accept(url)
    }
}
