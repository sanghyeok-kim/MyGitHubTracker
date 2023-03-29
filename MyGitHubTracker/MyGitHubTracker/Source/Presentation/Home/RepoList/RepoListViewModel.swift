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
    }
    
    struct Output {
        let fetchedRepositories = PublishRelay<[RepositoryEntity]>()
        let toastErrorMessage = PublishRelay<String>()
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
            .bind(to: output.fetchedRepositories)
            .disposed(by: disposeBag)
        
        fetchedRepositories
            .compactMap { $0.error }
            .bind(to: output.toastErrorMessage)
            .disposed(by: disposeBag)
    }
}
