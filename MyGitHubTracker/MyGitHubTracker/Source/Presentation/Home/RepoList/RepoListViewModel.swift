//
//  RepoListViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class RepoListViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let cellDidSelect = PublishRelay<IndexPath>()
        let cellWillDisplay = PublishRelay<IndexPath>()
    }
    
    struct Output {
        let repositoryCellViewModels = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let showErrorMessage = PublishRelay<String>()
    }
    
    let input = Input()
    let output = Output()
    
    private var paginationState = PaginationState()
    
    @Inject private var repoListUseCase: RepoListUseCase
    
    private weak var coordinator: RepoListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepoListCoordinator) {
        self.coordinator = coordinator
        
        // MARK: - Event from View Input
        
        input.viewDidLoad
            .withUnretained(self)
            .bind { `self`, _ in
                let (perPage, page) = self.paginationState.parameters
                self.repoListUseCase.fetchRepositories(perPage: perPage, page: page)
            }
            .disposed(by: disposeBag)
        
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.repoListUseCase.fetchRepositories(perPage: 10, page: 1)
            }
            .materialize()
            .share()
        
        input.cellWillDisplay
            .withUnretained(self)
            .bind { `self`, indexPath in
                self.loadNextPageIfNeeded(for: indexPath)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Event from UseCase
        
        repoListUseCase.fetchedRepositories
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.paginationState.isLoading = false
            })
            .map { $0.map { RepositoryCellViewModel(coordinator: coordinator, repositoryEntity: $0) } }
            .withLatestFrom(output.repositoryCellViewModels) { $1 + $0 }
            .bind(to: output.repositoryCellViewModels)
            .disposed(by: disposeBag)
        
        repoListUseCase.errorDidOccur
            .map { $0.localizedDescription }
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension RepoListViewModel {
    private func loadNextPageIfNeeded(for indexPath: IndexPath) {
        if paginationState.isLoading { return }
        
        let threshold = output.repositoryCellViewModels.value.count - 1
        if indexPath.row == threshold {
            paginationState.prepareNextPage()
            let (perPage, page) = paginationState.parameters
            repoListUseCase.fetchRepositories(perPage: perPage, page: page)
        }
    }
}

private extension RepoListViewModel {
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
