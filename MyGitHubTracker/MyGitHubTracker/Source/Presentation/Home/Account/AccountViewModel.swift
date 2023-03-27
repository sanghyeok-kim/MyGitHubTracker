//
//  AccountViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class AccountViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        let userInfo = PublishRelay<UserEntity>()
        let errorDidOccur = PublishRelay<String>()
    }
    
    let input = Input()
    let output = Output()
    
    @Inject private var accountUseCase: AccountUseCase
    
    private weak var coordinator: AccountCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator) {
        self.coordinator = coordinator
        
        let userInfo = input.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.accountUseCase.fetchUserInfo()
            }
            .materialize()
            .share()
        
        userInfo
            .compactMap { $0.element }
            .bind(to: output.userInfo)
            .disposed(by: disposeBag)
        
        userInfo
            .compactMap { $0.error?.localizedDescription }
            .bind(to: output.errorDidOccur)
            .disposed(by: disposeBag)
    }
}
