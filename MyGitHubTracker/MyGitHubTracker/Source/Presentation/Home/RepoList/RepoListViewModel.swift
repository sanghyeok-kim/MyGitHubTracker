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
    }
    
    struct Output {
        let repositoryCellViewModels = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let showErrorMessage = PublishRelay<String>()
    }
    
    let input = Input()
    let output = Output()
    
    @Inject private var repoListUseCase: RepoListUseCase
    
    private weak var coordinator: RepoListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepoListCoordinator) {
        self.coordinator = coordinator
        
        let fetchedRepositories = input.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.repoListUseCase.fetchRepositories(perPage: 10, page: 1)
            }
            .materialize()
            .share()
        
        fetchedRepositories
            .compactMap { $0.element }
            .map { $0.map { RepositoryCellViewModel(repositoryEntity:$0) } }
            .bind(to: output.repositoryCellViewModels)
            .disposed(by: disposeBag)
        
        fetchedRepositories
            .compactMap { $0.error }
            .catchAndLogError(logType: .error)
            .toastMeessageMap(to: .failToFetchRepositories)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
    }
}
