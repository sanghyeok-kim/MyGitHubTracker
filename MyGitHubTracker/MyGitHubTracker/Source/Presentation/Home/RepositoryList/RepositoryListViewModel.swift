//
//  RepositoryListViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class RepositoryListViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let cellDidTap = PublishRelay<IndexPath>()
        let tableViewDidRefresh = PublishRelay<Void>()
        let cellWillDisplay = PublishRelay<IndexPath>()
    }
    
    struct Output {
        let isLoadingIndicatorVisible = BehaviorRelay<Bool>(value: true)
        let repositoryCellViewModels = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let showErrorMessage = PublishRelay<String>()
        let endTableViewRefresh = PublishRelay<Void>()
    }
    
    struct State {
        let repositories = BehaviorRelay<[RepositoryEntity]>(value: [])
        let paginationState = BehaviorRelay<PaginationState>(value: PaginationState())
    }
    
    let input = Input()
    let output = Output()
    let state = State()
    
    @Inject private var starringUseCase: StarringUseCase
    @Inject private var repositoryListUseCase: RepositoryListUseCase
    @Inject private var paginationUseCase: PaginationUseCase
    
    private weak var coordinator: RepositoryListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepositoryListCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - viewDidLoad
        
        let fetchedRepositories = input.viewDidLoad
            .withLatestFrom(state.paginationState) { $1.fetchParameters }
            .withUnretained(self)
            .flatMapMaterialized { `self`, fetchParameters in
                let (perPage, page) = fetchParameters
                return self.repositoryListUseCase.fetchUserRepositories(perPage: perPage, page: page)
            }
            .share()
        
        fetchedRepositories
            .compactMap { $0.element }
            .bind(to: state.repositories)
            .disposed(by: disposeBag)
        
        fetchedRepositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        fetchedRepositories
            .compactMap { $0.error }
            .map { _ in false }
            .bind(to: output.isLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - tableViewDidRefresh
        
        input.tableViewDidRefresh
            .withLatestFrom(state.paginationState)
            .withUnretained(self)
            .compactMap { `self`, paginationState in
                self.paginationUseCase.resetToInitial(paginationState)
            }
            .bind(to: state.paginationState)
            .disposed(by: disposeBag)
        
        let refreshedRepositories = input.tableViewDidRefresh
            .withLatestFrom(state.paginationState) { $1.fetchParameters }
            .withUnretained(self)
            .flatMapMaterialized { `self`, fetchParameters in
                let (perPage, page) = fetchParameters
                return self.repositoryListUseCase.fetchUserRepositories(perPage: perPage, page: page)
            }
            .share()
        
        refreshedRepositories
            .compactMap { $0.element }
            .bind(to: state.repositories)
            .disposed(by: disposeBag)
        
        refreshedRepositories
            .compactMap { $0.element }
            .map { _ in }
            .bind(to: output.endTableViewRefresh)
            .disposed(by: disposeBag)
        
        refreshedRepositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        refreshedRepositories
            .compactMap { $0.error }
            .map { _ in }
            .bind(to: output.endTableViewRefresh)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - cellWillDisplay
        
        input.cellWillDisplay
            .withLatestFrom(state.paginationState) { ($0, $1) }
            .filter { !$1.isLoading }
            .map { $0.0 }
            .withUnretained(self)
            .bind { `self`, indexPath in
                self.loadNextPage(for: indexPath)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - cellDidTap
        
        input.cellDidTap
            .withLatestFrom(output.repositoryCellViewModels) { ($0, $1)  }
            .map { indexPath, cellViewModel -> RepositoryCellViewModel in
                return cellViewModel[indexPath.row]
            }
            .bind { $0.cellDidTap() }
            .disposed(by: disposeBag)
        
        // MARK: - Bind State - userRepositories
        
        let repositories = state.repositories
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .flatMapMaterialized { `self`, repositoryEntities -> Observable<([RepositoryEntity], [Bool])> in
                self.zipIsStarredByUser(with: repositoryEntities)
            }
            .share()
        
        repositories
            .compactMap { $0.element }
            .withLatestFrom(state.paginationState)
            .compactMap { [weak self] in
                self?.paginationUseCase.toggle($0, isLoading: false)
            }
            .bind(to: state.paginationState)
            .disposed(by: disposeBag)
        
        repositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let updatedIsStarredRepositoryEntities = repositories
            .compactMap { $0.element }
            .withUnretained(self)
            .map { `self`, result -> [RepositoryEntity] in
                let (repositoryEntities, isStarredByUsers) = result
                return self.updateIsStarredByUser(of: repositoryEntities, bools: isStarredByUsers)
            }
            .share()
        
        updatedIsStarredRepositoryEntities
            .map { $0.map { RepositoryCellViewModel(coordinator: coordinator, repository: $0) } }
            .bind(to: output.repositoryCellViewModels)
            .disposed(by: disposeBag)
        
        updatedIsStarredRepositoryEntities
            .map { _ in false }
            .distinctUntilChanged()
            .bind(to: output.isLoadingIndicatorVisible)
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension RepositoryListViewModel {
    func loadNextPage(for indexPath: IndexPath) {
        let threshold = output.repositoryCellViewModels.value.count - 1
        if indexPath.row == threshold {
            let nextPage = paginationUseCase.prepareNextPage(state.paginationState.value)
            state.paginationState.accept(nextPage)
            
            let (perPage, page) = nextPage.fetchParameters
            let fetchedNextPageUserRepositories = repositorySearchUseCase
                .fetchUserRepositories(perPage: perPage, page: page)
                .materialize()
                .share()
            
            fetchedNextPageUserRepositories
                .compactMap { $0.element }
                .withLatestFrom(state.repositories) { $1 + $0 }
                .bind(to: state.repositories)
                .disposed(by: disposeBag)
            
            fetchedNextPageUserRepositories
                .compactMap { $0.error }
                .doLogError()
                .toastMeessageMap(to: .failToFetchRepositories)
                .bind(to: output.showErrorMessage)
                .disposed(by: disposeBag)
        }
    }
    
    func zipIsStarredByUser(with repositories: [RepositoryEntity]) -> Observable<([RepositoryEntity], [Bool])> {
        let isStarredObservables = repositories.map {
            starringUseCase.checkRepositoryIsStarred(ownerName: $0.ownerName, repositoryName: $0.name)
        }
        return Observable.zip(Observable.just(repositories), Observable.combineLatest(isStarredObservables))
    }
    
    func updateIsStarredByUser(of repositories: [RepositoryEntity], bools: [Bool]) -> [RepositoryEntity] {
        return repositories.enumerated().map { index, repository -> RepositoryEntity in
            var updatedRepository = repository
            updatedRepository.isStarredByUser = bools[index]
            return updatedRepository
        }
    }
}
