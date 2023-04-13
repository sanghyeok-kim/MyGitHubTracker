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
        let userRepositories = BehaviorRelay<[RepositoryEntity]>(value: [])
        fileprivate var paginationState = PaginationState()
    }
    
    let input = Input()
    let output = Output()
    private var state = State()
    
    @Inject private var repositorySearchUseCase: RepositorySearchUseCase
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: RepositoryListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepositoryListCoordinator) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input: viewDidLoad
        
        let fetchedUserRepositories = input.viewDidLoad
            .withUnretained(self)
            .flatMapMaterialized { `self`, _ in
                let (perPage, page) = self.state.paginationState.parameters
                return self.repositorySearchUseCase.fetchUserRepositories(perPage: perPage, page: page)
            }
            .share()
        
        fetchedUserRepositories
            .compactMap { $0.element }
            .bind(to: state.userRepositories)
            .disposed(by: disposeBag)
        
        fetchedUserRepositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        fetchedUserRepositories
            .compactMap { $0.error }
            .map { _ in false }
            .bind(to: output.isLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State: userRepositories
        
        let fetchedRepositoryEntities = state.userRepositories
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.state.paginationState.isLoading = false
            })
            .withUnretained(self)
            .flatMapMaterialized { `self`, repositoryEntities -> Observable<([RepositoryEntity], [Bool])> in
                self.zipIsStarredByUser(with: repositoryEntities)
            }
            .share()
        
        fetchedRepositoryEntities
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        let updatedIsStarredRepositoryEntities = fetchedRepositoryEntities
            .compactMap { $0.element }
            .withUnretained(self)
            .map { `self`, result -> [RepositoryEntity] in
                let (repositoryEntities, isStarredByUsers) = result
                return self.updateIsStarredByUser(of: repositoryEntities, bools: isStarredByUsers)
            }
            .share()
        
        updatedIsStarredRepositoryEntities
            .map { $0.map { RepositoryCellViewModel(coordinator: coordinator, repositoryEntity: $0) } }
            .withLatestFrom(output.repositoryCellViewModels) { $1 + $0 }
            .bind(to: output.repositoryCellViewModels)
            .disposed(by: disposeBag)
        
        updatedIsStarredRepositoryEntities
            .map { _ in false }
            .distinctUntilChanged()
            .bind(to: output.isLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input: tableViewDidRefresh
        
        input.tableViewDidRefresh
            .withUnretained(self)
            .bind { `self`, _ in
                self.refreshToInitialPage()
            }
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input: cellWillDisplay
        
        input.cellWillDisplay
            .withUnretained(self)
            .bind { `self`, indexPath in
                self.loadNextPageIfNeeded(for: indexPath)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input: cellDidTap
        
        input.cellDidTap
            .withLatestFrom(output.repositoryCellViewModels) { ($0, $1)  }
            .map { indexPath, cellViewModel -> RepositoryCellViewModel in
                return cellViewModel[indexPath.row]
            }
            .bind { $0.cellDidTap() }
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension RepositoryListViewModel {
    func loadNextPageIfNeeded(for indexPath: IndexPath) {
        if state.paginationState.isLoading { return }
        
        let threshold = output.repositoryCellViewModels.value.count - 1
        if indexPath.row == threshold {
            state.paginationState.prepareNextPage()
            let (perPage, page) = state.paginationState.parameters
            
            let fetchedUserRepositories = repositorySearchUseCase
                .fetchUserRepositories(perPage: perPage, page: page)
                .materialize()
                .share()
            
            fetchedUserRepositories
                .compactMap { $0.element }
                .bind(to: state.userRepositories)
                .disposed(by: disposeBag)
            
            fetchedUserRepositories
                .compactMap { $0.error }
                .doLogError()
                .toastMeessageMap(to: .failToFetchRepositories)
                .bind(to: output.showErrorMessage)
                .disposed(by: disposeBag)
        }
    }
    
    func refreshToInitialPage() {
        output.repositoryCellViewModels.accept([])
        state.paginationState.resetToInitial()
        
        let (perPage, page) = state.paginationState.parameters
        let fetchedUserRepositories = repositorySearchUseCase
            .fetchUserRepositories(perPage: perPage, page: page)
            .materialize()
            .share()
        
        fetchedUserRepositories
            .compactMap { $0.element }
            .bind(to: state.userRepositories)
            .disposed(by: disposeBag)
        
        fetchedUserRepositories
            .compactMap { $0.element }
            .map { _ in }
            .bind(to: output.endTableViewRefresh)
            .disposed(by: disposeBag)
        
        fetchedUserRepositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        fetchedUserRepositories
            .compactMap { $0.error }
            .map { _ in }
            .bind(to: output.endTableViewRefresh)
            .disposed(by: disposeBag)
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

// MARK: - State Models

private extension RepositoryListViewModel {
    struct PaginationState {
        private let startPage = 1
        private let repositoryCountPerPage: Int = 10
        var currentPage: Int
        var isLoading: Bool
        
        var parameters: (perPage: Int, currentPage: Int) {
            return (repositoryCountPerPage, currentPage)
        }
        
        init() {
            self.currentPage = startPage
            self.isLoading = false
        }
        
        mutating func resetToInitial() {
            currentPage = startPage
            isLoading = false
        }
        
        mutating func prepareNextPage() {
            isLoading = true
            currentPage += 1
        }
    }
}
