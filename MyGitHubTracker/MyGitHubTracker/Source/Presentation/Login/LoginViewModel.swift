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
        
        input.userDidAuthorize
            .withUnretained(self)
            .flatMapLatest { `self`, url in
                self.loginUseCase.fetchAndStoreAccessToken(with: url)
            }
            .subscribe { _ in
                coordinator.coordinate(by: .accessTokenDidfetch)
            } onError: { error in
                // FIXME: 에러 처리하기
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}

// MARK: - External Methods

extension LoginViewModel {
    func userDidAuthorize(callBack url: URL) {
        input.userDidAuthorize.accept(url)
    }
}
