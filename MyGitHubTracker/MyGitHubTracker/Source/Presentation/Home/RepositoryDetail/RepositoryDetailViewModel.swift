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
    
    let input = Input()
    let output = Output()
    
    @Inject private var repositorySearchUseCase: RepositorySearchUseCase
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: RepositoryListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepositoryListCoordinator?, repository: RepositoryEntity) {
        
        // MARK: - Bind Input: viewDidLoad
        
        let fetchedRepositoryDetail = input.viewDidLoad
            .withUnretained(self)
            .flatMap { `self`, _ in
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
        
        fetchedRepositoryDetail
            .map { _ in false }
            .distinctUntilChanged()
            .bind(to: output.isFetchingData)
            .disposed(by: disposeBag)
        
        fetchedRepositoryDetail
            .map { $0.avatarImageURL }
            .bind(to: output.avatarImageURL)
            .disposed(by: disposeBag)
        
        fetchedRepositoryDetail
            .map { $0.ownerName }
            .bind(to: output.ownerName)
            .disposed(by: disposeBag)
        
        fetchedRepositoryDetail
            .map { $0.name }
            .bind(to: output.name)
            .disposed(by: disposeBag)
        
        fetchedRepositoryDetail
            .map { $0.description }
            .bind(to: output.description)
            .disposed(by: disposeBag)
        
        fetchedRepositoryDetail
            .map { $0.stargazersCount }
            .bind(to: output.starCount)
            .disposed(by: disposeBag)
        
        fetchedRepositoryDetail
            .map { $0.isStarredByUser }
            .bind(to: output.isStarredByUser)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input: starringButtonDidTap
        
        let isStarredByUserWhenStarringButtonDidTap = input.starringButtonDidTap
            .withLatestFrom(Observable.combineLatest(output.ownerName, output.name))
            .withUnretained(self) { ($0, $1) }
            .flatMapMaterialized { `self`, name -> Observable<Bool> in
                let (userName, repositoryName) = name
                return self.starringUseCase.checkRepositoryIsStarred(ownerName: userName, repositoryName: repositoryName)
            }
            .share()
        
        isStarredByUserWhenStarringButtonDidTap
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let repositoryDidStar = isStarredByUserWhenStarringButtonDidTap
            .compactMap { $0.element }
            .filter { !$0 }
            .withLatestFrom(Observable.combineLatest(output.ownerName, output.name))
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, name in
                let (userName, repositoryName) = name
                return self.starringUseCase.starRepository(ownerName: userName, repositoryName: repositoryName)
            }
            .share()
        
        repositoryDidStar
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        repositoryDidStar
            .compactMap { $0.element }
            .map { true }
            .bind(to: output.isStarredByUser)
            .disposed(by: disposeBag)
        
        let repositoryDidUnstar = isStarredByUserWhenStarringButtonDidTap
            .compactMap { $0.element }
            .filter { $0 }
            .withLatestFrom(Observable.combineLatest(output.ownerName, output.name))
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, nameInfo in
                let (ownerName, repositoryName) = nameInfo
                return self.starringUseCase.unstarRepository(ownerName: ownerName, repositoryName: repositoryName)
            }
            .share()
        
        repositoryDidUnstar
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        repositoryDidUnstar
            .compactMap { $0.element }
            .map { false }
            .bind(to: output.isStarredByUser)
            .disposed(by: disposeBag)
        
        let starringDidFinished = Observable.merge(repositoryDidStar, repositoryDidUnstar)
            .withLatestFrom(Observable.combineLatest(output.ownerName, output.name))
            .withUnretained(self)
            .flatMapMaterialized { `self`, repositoryInfo -> Observable<RepositoryEntity> in
                let (owenrName, repositoryName) = repositoryInfo
                return self.repositorySearchUseCase.fetchRepositoryDetail(ownerName: owenrName, repositoryName: repositoryName)
            }
            .share()
        
        starringDidFinished
            .compactMap { $0.element }
            .map { $0.stargazersCount }
            .bind(to: output.starCount)
            .disposed(by: disposeBag)
        
        starringDidFinished
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToStarring)
            .bind(to: output.showErrorMessage)
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
