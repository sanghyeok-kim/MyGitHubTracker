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
    
    private weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: LoginCoordinator) {
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
            .flatMap { `self`, url -> Observable<Void> in
                self.loginUseCase.fetchAndStoreAccessToken(with: url).andThen(.just(()))
            }
            .subscribe(with: self, onNext: { `self`, _ in
                self.coordinator?.coordinate(by: .accessTokenDidfetch)
            }, onError: { `self`, error in
                self.output.showErrorMessage.accept(ToastError.failToFetchAccessToken.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - External Methods

extension LoginViewModel {
    func userDidAuthorize(callBack url: URL) {
        input.userDidAuthorize.accept(url)
    }
}
