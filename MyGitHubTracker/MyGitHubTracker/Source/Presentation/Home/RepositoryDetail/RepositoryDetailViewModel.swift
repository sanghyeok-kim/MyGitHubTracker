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
        let isFetchingData = BehaviorRelay<Bool>(value: true)
        let avatarImageURL = BehaviorRelay<URL?>(value: nil)
        let ownerName = BehaviorRelay<String>(value: "")
        let name = BehaviorRelay<String>(value: "")
        let description = BehaviorRelay<String?>(value: nil)
        let starCount = BehaviorRelay<Int>(value: .zero)
        let isStarredByUser = BehaviorRelay<Bool>(value: false)
        let showErrorMessage = PublishRelay<String>()
    }
    
    struct State {
        let repository: BehaviorRelay<RepositoryEntity>
    }
    
    let input = Input()
    let output = Output()
    let state: State
    
    @Inject private var repositoryUseCase: RepositoryUseCase
    @Inject private var repositorySearchUseCase: RepositorySearchUseCase
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: RepositoryListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepositoryListCoordinator?, repository: RepositoryEntity) {
        self.coordinator = coordinator
        self.state = State(repository: BehaviorRelay<RepositoryEntity>(value: repository))
        
        // MARK: - Binding Input - viewDidLoad
        
        let repositoryStarringInfoDidFetch = input.viewDidLoad
            .withLatestFrom(state.repository)
            .withUnretained(self)
            .flatMap { `self`, repository in
                self.repositorySearchUseCase.fetchRepositoryDetail(
                    ownerName: repository.ownerName,
                    repositoryName: repository.name
                )
            }
            .withUnretained(self)
            .flatMap { `self`, repositoryEntity -> Observable<(RepositoryEntity, Bool)> in
                self.zipIsStarredByUser(with: repositoryEntity)
            }
            .withUnretained(self)
            .map { `self`, result -> RepositoryEntity in
                let (repositoryEntity, isStarredByUser) = result
                return self.updateIsStarredByUser(of: repositoryEntity, bool: isStarredByUser)
            }
            .share()
        
        repositoryStarringInfoDidFetch
            .bind(to: state.repository)
            .disposed(by: disposeBag)
        
        repositoryStarringInfoDidFetch
            .map { _ in false }
            .distinctUntilChanged()
            .bind(to: output.isFetchingData)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - starringButtonDidTap
        
        input.starringButtonDidTap
            .withLatestFrom(state.repository)
            .compactMap { [weak self] in
                self?.repositoryUseCase.toggleStargazersCount($0)
            }
            .bind(to: state.repository)
            .disposed(by: disposeBag)
        
        input.starringButtonDidTap
            .withLatestFrom(state.repository)
            .compactMap { [weak self] in
                self?.repositoryUseCase.toggleIsStarredByUser($0)
            }
            .bind(to: state.repository)
            .disposed(by: disposeBag)
        
        let checkRepositoryIsStarredWhenStarringButtonDidTap = input.starringButtonDidTap
            .withLatestFrom(state.repository) { ($1.ownerName, $1.name) }
            .withUnretained(self)
            .flatMapMaterialized { `self`, name -> Observable<Bool> in
                let (userName, repositoryName) = name
                return self.starringUseCase.checkRepositoryIsStarred(ownerName: userName, repositoryName: repositoryName)
            }
            .share()
        
        checkRepositoryIsStarredWhenStarringButtonDidTap
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let repositoryStarringDidFinish = checkRepositoryIsStarredWhenStarringButtonDidTap
            .compactMap { $0.element }
            .withLatestFrom(state.repository) { (isRemoteStarred: $0, ownerName: $1.ownerName, repositoryName: $1.name) }
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, starringStatus in
                let (isRemoteStarred, ownerName, repositoryName) = starringStatus
                return self.starringUseCase.toggleStarringRepository(ownerName: ownerName, repositoryName: repositoryName, shouldStar: isRemoteStarred)
            }
            .share()
        
        repositoryStarringDidFinish
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let starringDidFinished = repositoryStarringDidFinish
            .withLatestFrom(state.repository) { ($1.ownerName, $1.name) }
            .withUnretained(self)
            .flatMapMaterialized { `self`, repositoryInfo -> Observable<RepositoryEntity> in
                let (owenrName, repositoryName) = repositoryInfo
                return self.repositorySearchUseCase.fetchRepositoryDetail(ownerName: owenrName, repositoryName: repositoryName)
            }
            .share()
        
        starringDidFinished
            .compactMap { $0.element }
            .map { $0.stargazersCount }
            .withLatestFrom(state.repository) { ($0, $1) }
            .filter { $0 != $1.stargazersCount }
            .compactMap { [weak self] count, repository in
                self?.repositoryUseCase.changeStargazersCount(repository, count: count)
            }
            .bind(to: state.repository)
            .disposed(by: disposeBag)
        
        starringDidFinished
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showErrorMessage)
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
    
    func updateIsStarredByUser(of repositoryEntity: RepositoryEntity, bool: Bool) -> RepositoryEntity {
        var updatedRepositoryEntity = repositoryEntity
        updatedRepositoryEntity.isStarredByUser = bool
        return updatedRepositoryEntity
    }
    
    func updateStargazerCount(of repositoryEntity: RepositoryEntity, count: Int) -> RepositoryEntity {
        var updatedRepositoryEntity = repositoryEntity
        updatedRepositoryEntity.stargazersCount = count
        return updatedRepositoryEntity
    }
}
