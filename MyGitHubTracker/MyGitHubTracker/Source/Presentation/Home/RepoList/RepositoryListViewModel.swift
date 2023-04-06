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
        let repositoryCellViewModels = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let showErrorMessage = PublishRelay<String>()
        let endTableViewRefresh = PublishRelay<Void>()
    }
    
    let input = Input()
    let output = Output()
    
    private var paginationState = PaginationState()
    
    @Inject private var repositorySearchUseCase: RepositorySearchUseCase
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: RepositoryListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepositoryListCoordinator) {
        self.coordinator = coordinator
        
        // MARK: - Event from View Input
        
        input.viewDidLoad
            .withUnretained(self)
            .bind { `self`, _ in
                let (perPage, page) = self.paginationState.parameters
                self.repositorySearchUseCase.fetchUserRepositories(perPage: perPage, page: page)
            }
            .disposed(by: disposeBag)
        
        input.tableViewDidRefresh
            .withUnretained(self)
            .bind { `self`, _ in
                self.refreshToInitialPage()
            }
            .disposed(by: disposeBag)
        
        input.cellWillDisplay
            .withUnretained(self)
            .bind { `self`, indexPath in
                self.loadNextPageIfNeeded(for: indexPath)
            }
            .disposed(by: disposeBag)
        
        input.cellDidTap
            .withLatestFrom(output.repositoryCellViewModels) { ($0, $1)  }
            .map { indexPath, cellViewModel -> RepositoryCellViewModel in
                return cellViewModel[indexPath.row]
            }
            .bind { $0.cellDidTap() }
            .disposed(by: disposeBag)
        
        // MARK: - Event from UseCase
        
        repositorySearchUseCase.fetchedUserRepositories
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.paginationState.isLoading = false
            })
            .withUnretained(self)
            .flatMap { `self`, repositoryEntities -> Observable<([RepositoryEntity], [Bool])> in
                self.zipIsStarredByUser(with: repositoryEntities)
            }
            .withUnretained(self)
            .map { `self`, result -> [RepositoryEntity] in
                let (repositoryEntities, isStarredByUsers) = result
                return self.updateIsStarredByUser(of: repositoryEntities, bools: isStarredByUsers)
            }
            .map { $0.map { RepositoryCellViewModel(coordinator: coordinator, repositoryEntity: $0) } }
            .withLatestFrom(output.repositoryCellViewModels) { $1 + $0 }
            .bind(to: output.repositoryCellViewModels)
            .disposed(by: disposeBag)
        
        repositorySearchUseCase.errorDidOccur
            .map { $0.localizedDescription }
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        Observable.merge(
            repositorySearchUseCase.fetchedUserRepositories.skip(1).map { _ in },
            repositorySearchUseCase.errorDidOccur.map { _ in }
        )
        .bind(to: output.endTableViewRefresh)
        .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension RepositoryListViewModel {
    private func loadNextPageIfNeeded(for indexPath: IndexPath) {
        if paginationState.isLoading { return }
        
        let threshold = output.repositoryCellViewModels.value.count - 1
        if indexPath.row == threshold {
            paginationState.prepareNextPage()
            let (perPage, page) = paginationState.parameters
            repositorySearchUseCase.fetchUserRepositories(perPage: perPage, page: page)
        }
    }
    
    private func refreshToInitialPage() {
        output.repositoryCellViewModels.accept([])
        paginationState.resetToInitial()
        let (perPage, page) = paginationState.parameters
        repositorySearchUseCase.fetchUserRepositories(perPage: perPage, page: page)
    }
    
    func zipIsStarredByUser(with repositories: [RepositoryEntity]) -> Observable<([RepositoryEntity], [Bool])> {
        let isStarredObservables = repositories.map {
            starringUseCase.checkRepositoryIsStarred(repositoryOwner: $0.ownerName, repositoryName: $0.name)
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
