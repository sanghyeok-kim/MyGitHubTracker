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
        let createRepositoryButtonDidTap = PublishRelay<Void>()
        let cellDidTap = PublishRelay<IndexPath>()
        let tableViewDidRefresh = PublishRelay<Void>()
        let cellWillDisplay = PublishRelay<IndexPath>()
    }
    
    struct Output {
        let isLoadingIndicatorVisible = BehaviorRelay<Bool>(value: true)
        let repositoryCellViewModels = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let showToastMessage = PublishRelay<String>()
        let isTableViewRefreshIndicatorVisible = BehaviorRelay<Bool>(value: false)
        let isFooterLoadingIndicatorVisible = BehaviorRelay<Bool>(value: false)
    }
    
    struct State {
        let repositories = BehaviorRelay<[RepositoryEntity]>(value: [])
        let paginationState = BehaviorRelay<PaginationState>(value: PaginationState())
    }
    
    let input = Input()
    let output = Output()
    let state = State()
    
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
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        fetchedRepositories
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.isLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        fetchedRepositories
            .compactMap { $0.element }
            .bind(to: state.repositories)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - createRepositoryButtonDidTap
        
        input.createRepositoryButtonDidTap
            .map { RepositoryCreationViewModel(coordinator: coordinator) }
            .do { [weak self] in
                self?.bindOutput(from: $0)
            }
            .bind {
                coordinator?.coordinate(by: .createRepositoryButtonDidTap(viewModel: $0))
            }
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
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        refreshedRepositories
            .compactMap { $0.element }
            .bind(to: state.repositories)
            .disposed(by: disposeBag)
        
        refreshedRepositories
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.isTableViewRefreshIndicatorVisible)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - cellDidTap
        
        input.cellDidTap
            .withLatestFrom(output.repositoryCellViewModels) { ($0, $1)  }
            .map { indexPath, cellViewModel -> RepositoryCellViewModel in
                return cellViewModel[indexPath.row]
            }
            .bind { $0.cellDidTap() }
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - cellWillDisplay
        
        let canFetchNextPageWhenTableViewWillDisplayLastIndex = input.cellWillDisplay
            .withLatestFrom(output.repositoryCellViewModels) { (indexPath: $0, cellViewModels: $1) }
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
        
        // MARK: - Bind State - repositories
        
        state.repositories
            .map { $0.map { RepositoryCellViewModel(coordinator: coordinator, repository: $0) } }
            .bind(to: output.repositoryCellViewModels)
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension RepositoryListViewModel {
    func fetchNextPage(for nextPage: PaginationState) {
        let (perPage, page) = nextPage.fetchParameters
        
        let fetchedNextPageUserRepositories = repositoryListUseCase
            .fetchUserRepositories(perPage: perPage, page: page)
            .materialize()
            .share()
        
        fetchedNextPageUserRepositories
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        fetchedNextPageUserRepositories
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.isFooterLoadingIndicatorVisible)
            .disposed(by: disposeBag)
        
        fetchedNextPageUserRepositories
            .compactMap { $0.element }
            .withLatestFrom(state.repositories) { $1 + $0 }
            .bind(to: state.repositories)
            .disposed(by: disposeBag)
        
        //empty -> 더 이상 요청할 데이터 없음 -> isLoading을 다시 false로 안바꿔줌 (계속 true로 유지해서 더 이상 요청하지 못하도록)
        fetchedNextPageUserRepositories
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

// MARK: - Binding Other ViewModels

private extension RepositoryListViewModel {
    func bindOutput(from repositoryCreationViewModel: RepositoryCreationViewModel) {
        let repositoryDidCreate = repositoryCreationViewModel.output
            .repositoryCreationDidFinish
            .share()
        
        repositoryDidCreate
            .bind(to: input.tableViewDidRefresh)
            .disposed(by: disposeBag)
        
        repositoryDidCreate
            .toastMeessageMap(to: .repositoryCreated)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
    }
}
