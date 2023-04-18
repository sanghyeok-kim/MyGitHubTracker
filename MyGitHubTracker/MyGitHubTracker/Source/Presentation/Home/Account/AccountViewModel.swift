//
//  AccountViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay
import RxCocoa

final class AccountViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        let loginID = BehaviorRelay<String>(value: "")
        let avatarImageURL = BehaviorRelay<URL?>(value: nil)
        let gitHubURL = BehaviorRelay<URL?>(value: nil)
        let followersURL = BehaviorRelay<String>(value: "")
        let followingURL = BehaviorRelay<String>(value: "")
        let name = BehaviorRelay<String>(value: "")
        let followersCount = BehaviorRelay<Int>(value: .zero)
        let followingCount = BehaviorRelay<Int>(value: .zero)
        let showToastMessage = PublishRelay<String>()
    }
    
    struct State {
        let user = PublishRelay<UserEntity>()
    }
    
    let input = Input()
    let output = Output()
    let state = State()
    
    @Inject private var accountUseCase: AccountUseCase
    
    private weak var coordinator: AccountCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - viewDidLoad
        
        let userInfo = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.accountUseCase.fetchUserInfo()
            }
            .share()
        
        userInfo
            .compactMap { $0.element }
            .bind(to: state.user)
            .disposed(by: disposeBag)
        
        userInfo
            .compactMap { $0.error }
            .doLogError(logType: .error)
            .toastMeessageMap(to: .failToFetchUserInformation)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State - user
        
        state.user
            .map { $0.loginID }
            .bind(to: output.loginID)
            .disposed(by: disposeBag)
        
        state.user
            .map { $0.avatarImageURL }
            .bind(to: output.avatarImageURL)
            .disposed(by: disposeBag)
        
        state.user
            .map { $0.gitHubURL }
            .bind(to: output.gitHubURL)
            .disposed(by: disposeBag)
        
        state.user
            .map { $0.name }
            .bind(to: output.name)
            .disposed(by: disposeBag)
        
        state.user
            .map { $0.followersCount }
            .bind(to: output.followersCount)
            .disposed(by: disposeBag)
        
        state.user
            .map { $0.followingCount }
            .bind(to: output.followingCount)
            .disposed(by: disposeBag)
    }
}
