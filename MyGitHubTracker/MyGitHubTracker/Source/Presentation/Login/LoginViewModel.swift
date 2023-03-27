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
    
    private weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        
    }
}

// MARK: - External Methods

extension LoginViewModel {
    func userDidAuthorize(callBack url: URL) {
        input.userDidAuthorize.accept(url)
    }
}
