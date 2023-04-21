//
//  RepositoryDetailViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/05.
//

import RxSwift
import RxRelay

final class RepositoryDetailViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let starringButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoadingIndicatorVisible = BehaviorRelay<Bool>(value: true)
        let avatarImageURL = BehaviorRelay<URL?>(value: nil)
        let ownerName = BehaviorRelay<String>(value: "")
        let name = BehaviorRelay<String>(value: "")
        let description = BehaviorRelay<String?>(value: nil)
        let starCount = BehaviorRelay<Int>(value: .zero)
        let isStarredByUser = BehaviorRelay<Bool>(value: false)
        let showToastMessage = PublishRelay<String>()
    }
    
    struct State {
        let repository = PublishRelay<RepositoryEntity>()
    }
    
    let input = Input()
    let output = Output()
    let state = State()
    
    @Inject private var repositoryUseCase: RepositoryUseCase
    @Inject private var repositoryDetailUseCase: RepositoryDetailUseCase
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: RepositoryListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepositoryListCoordinator?, repository: RepositoryEntity) {
        self.coordinator = coordinator
        
        // MARK: - Binding Input - viewDidLoad
        
        let remoteRepositoryDetailDidFetch = input.viewDidLoad
            .map { (repository.ownerName, repository.name) }
            .withUnretained(self)
            .flatMap { `self`, repositoryNameInfo in
                let (ownerName, repositoryName) = repositoryNameInfo
                return self.repositoryDetailUseCase.fetchRepositoryDetail(ownerName: ownerName, repositoryName: repositoryName)
            }
            .withUnretained(self)
            .flatMap { `self`, repositoryEntity -> Observable<(RepositoryEntity, Bool)> in
                self.zipIsStarredByUser(with: repositoryEntity)
            }
            .withUnretained(self)
            .map { `self`, zipResult -> RepositoryEntity in
                let (repositoryEntity, isStarredByUser) = zipResult
                return self.repositoryUseCase.changeIsStarredByUser(repositoryEntity, isStarred: isStarredByUser)
            }
            .share()
        
        remoteRepositoryDetailDidFetch
            .bind(to: state.repository)
            .disposed(by: disposeBag)
        
        remoteRepositoryDetailDidFetch
            .map { _ in false }
            .distinctUntilChanged()
            .bind(to: output.isLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - starringButtonDidTap
        
        input.starringButtonDidTap
            .withLatestFrom(state.repository)
            .compactMap { [weak self] in
                self?.repositoryUseCase.toggleStargazersCount($0)
            }
            .compactMap { [weak self] in
                self?.repositoryUseCase.toggleIsStarredByUser($0)
            }
            .bind(to: state.repository)
            .disposed(by: disposeBag)
        
        let remoteRepositoryIsStarred = input.starringButtonDidTap
            .withLatestFrom(state.repository) { ($1.ownerName, $1.name) }
            .withUnretained(self)
            .flatMapMaterialized { `self`, name -> Observable<Bool> in
                let (userName, repositoryName) = name
                return self.starringUseCase.checkRepositoryIsStarred(ownerName: userName, repositoryName: repositoryName)
            }
            .share()
        
        remoteRepositoryIsStarred
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        let remoteRpositoryStarringDidToggle = remoteRepositoryIsStarred
            .compactMap { $0.element }
            .withLatestFrom(state.repository) { (isRemoteStarred: $0, ownerName: $1.ownerName, repositoryName: $1.name) }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, starringStatus in
                let (isRemoteStarred, ownerName, repositoryName) = starringStatus
                return self.starringUseCase.toggleRepositoryStarring(
                    ownerName: ownerName,
                    repositoryName: repositoryName,
                    isStarred: isRemoteStarred
                )
            }
            .share()
        
        remoteRpositoryStarringDidToggle
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        let remoteRepositoryResultAfterStarring = remoteRpositoryStarringDidToggle
            .withLatestFrom(state.repository) { ($1.ownerName, $1.name) }
            .withUnretained(self)
            .flatMapMaterialized { `self`, repositoryNameInfo -> Observable<RepositoryEntity> in
                let (ownerName, repositoryName) = repositoryNameInfo
                return self.repositoryDetailUseCase.fetchRepositoryDetail(ownerName: ownerName, repositoryName: repositoryName)
            }
            .share()
        
        remoteRepositoryResultAfterStarring
            .compactMap { $0.element }
            .map { $0.stargazersCount }
            .withLatestFrom(state.repository) { (remoteRepositoryStarCount: $0, displayedRepository: $1) }
            .filter { $0 != $1.stargazersCount }
            .compactMap { [weak self] remoteCount, repository in
                self?.repositoryUseCase.changeStargazersCount(repository, count: remoteCount)
            }
            .bind(to: state.repository)
            .disposed(by: disposeBag)
        
        remoteRepositoryResultAfterStarring
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State - repository
        
        state.repository
            .map { $0.avatarImageURL }
            .bind(to: output.avatarImageURL)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.ownerName }
            .bind(to: output.ownerName)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.name }
            .bind(to: output.name)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.description }
            .bind(to: output.description)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.stargazersCount }
            .bind(to: output.starCount)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.isStarredByUser }
            .bind(to: output.isStarredByUser)
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension RepositoryDetailViewModel {
    func zipIsStarredByUser(with repositoryEntity: RepositoryEntity) -> Observable<(RepositoryEntity, Bool)> {
        let (ownerName, repositoryName) = (repositoryEntity.ownerName, repositoryEntity.name)
        let isStarredByUserObservable = self.starringUseCase.checkRepositoryIsStarred(
            ownerName: ownerName,
            repositoryName: repositoryName
        )
        return Observable.zip(Observable.just(repositoryEntity), isStarredByUserObservable)
    }
}
