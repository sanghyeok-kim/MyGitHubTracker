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
        let starredRepositorySections = BehaviorRelay<[StarredRepositorySection]>(value: [])
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
        let starredRepositories = BehaviorRelay<[RepositoryEntity]>(value: [])
        let headerViewModel = PublishRelay<StarredRepositoryHeaderViewModel>()
        let starredRepositoryCellViewModels = BehaviorRelay<[StarredRepositoryCellViewModel]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    let state = State()
    
    @Inject private var accountUseCase: AccountUseCase
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: AccountCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - viewDidLoad
        
        input.viewDidLoad
            .map { StarredRepositoryHeaderViewModel(coordinator: coordinator) }
            .bind(to: state.headerViewModel)
            .disposed(by: disposeBag)
        
        let starredRepositories = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                self.starringUseCase.fetchUserStarredRepositories(perPage: 5, page: 1)
            }
            .share()
        
        starredRepositories
            .compactMap { $0.element }
            .bind(to: state.starredRepositories)
            .disposed(by: disposeBag)
        
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
        
        // MARK: - Bind State - starredRepositories
        
        state.starredRepositories
            .map { $0.map { StarredRepositoryCellViewModel(coordinator: coordinator, repository: $0) } }
            .bind(to: state.starredRepositoryCellViewModels)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State - starredRepositories, headerViewModel
        
        Observable.combineLatest(
            state.starredRepositoryCellViewModels.filter { !$0.isEmpty },
            state.headerViewModel
        )
        .map { (items, headerViewModel) -> [StarredRepositorySection] in
            let section = StarredRepositorySection(items: items, headerViewModel: headerViewModel)
            return [section]
        }
        .bind(to: output.starredRepositorySections)
        .disposed(by: disposeBag)
    }
}
