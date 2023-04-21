//
//  StarredRepositoryListViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/21.
//

import RxSwift
import RxRelay

final class StarredRepositoryListViewModel: ViewModelType {
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let cellDidTap = PublishRelay<IndexPath>()
        let tableViewDidRefresh = PublishRelay<Void>()
        let cellWillDisplay = PublishRelay<IndexPath>()
    }
    
    struct Output {
        let starredRepositorySections = BehaviorRelay<[StarredRepositorySection]>(value: [])
        let isLoadingIndicatorVisible = BehaviorRelay<Bool>(value: true)
        let repositorySections = BehaviorRelay<[RepositorySection]>(value: [])
        let showToastMessage = PublishRelay<String>()
        let isTableViewRefreshIndicatorVisible = BehaviorRelay<Bool>(value: false)
        let isFooterLoadingIndicatorVisible = BehaviorRelay<Bool>(value: false)
    }
    
    struct State {
        let starredRepositories = BehaviorRelay<[RepositoryEntity]>(value: [])
        let paginationState = BehaviorRelay<PaginationState>(value: PaginationState(startPage: 1, countPerPage: 7))
        let starredRepositoryCellViewModels = BehaviorRelay<[StarredRepositoryCellViewModel]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    let state = State()
    
    @Inject private var starringUseCase: StarringUseCase
    @Inject private var paginationUseCase: PaginationUseCase
    
    weak var coordinator: AccountCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - viewDidLoad
        
        let fetchedStarredRepositories = input.viewDidLoad
            .withLatestFrom(state.paginationState) { $1.fetchParameters }
            .withUnretained(self)
            .flatMapMaterialized { `self`, fetchParameters in
                let (perPage, page) = fetchParameters
                return self.starringUseCase.fetchUserStarredRepositories(perPage: perPage, page: page)
            }
            .share()
        
        fetchedStarredRepositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        fetchedStarredRepositories
            .compactMap { $0.element }
            .bind(to: state.starredRepositories)
            .disposed(by: disposeBag)
        
        fetchedStarredRepositories
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.isLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - cellWillDisplay
        
        let canFetchNextPageWhenTableViewWillDisplayLastIndex = input.cellWillDisplay
            .withLatestFrom(state.starredRepositoryCellViewModels) { (indexPath: $0, cellViewModels: $1) }
            .filter { $0.row == $1.count - 1 }
            .map { $0.0 }
            .withLatestFrom(state.paginationState) { (indexPath: $0, paginationState: $1) }
            .filter { $1.canLoad }
            .share()
        
        canFetchNextPageWhenTableViewWillDisplayLastIndex
            .map { _ in true }
            .bind(to: output.isFooterLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        let paginationStateForNextPage = canFetchNextPageWhenTableViewWillDisplayLastIndex
            .withLatestFrom(state.paginationState)
            .withUnretained(self) { ($0, $1) }
            .compactMap { `self`, paginationState in
                self.paginationUseCase.prepareNextPage(paginationState)
            }
            .share()
        
        paginationStateForNextPage
            .do { [weak self] in
                self?.state.paginationState.accept($0)
            }
            .withUnretained(self)
            .bind { `self`, paginationState in
                self.fetchNextPage(for: paginationState)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Bind State - starredRepositories
        
        state.starredRepositories
            .map { $0.map { StarredRepositoryCellViewModel(coordinator: coordinator, repository: $0) } }
            .bind(to: state.starredRepositoryCellViewModels)
            .disposed(by: disposeBag)
        
        
        // MARK: - Bind State - starredRepositoryCellViewModels
        
        state.starredRepositoryCellViewModels
            .map { [StarredRepositorySection(items: $0)] }
            .bind(to: output.starredRepositorySections)
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension StarredRepositoryListViewModel {
    func fetchNextPage(for nextPage: PaginationState) {
        let (perPage, page) = nextPage.fetchParameters
        
        let fetchedNextPageStarredRepositories = starringUseCase
            .fetchUserStarredRepositories(perPage: perPage, page: page)
            .materialize()
            .share()
        
        fetchedNextPageStarredRepositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        fetchedNextPageStarredRepositories
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.isFooterLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        fetchedNextPageStarredRepositories
            .compactMap { $0.element }
            .withLatestFrom(state.starredRepositories) { $1 + $0 }
            .debug()
            .bind(to: state.starredRepositories)
            .disposed(by: disposeBag)
        
        fetchedNextPageStarredRepositories
            .compactMap { $0.element }
            .filter { !$0.isEmpty }
            .withLatestFrom(state.paginationState)
            .compactMap { [weak self] in
                self?.paginationUseCase.finishLoading($0)
            }
            .bind(to: state.paginationState)
            .disposed(by: disposeBag)
    }
}
