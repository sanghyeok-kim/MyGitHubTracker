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
    }
    
    struct Output {
        
    }
    
    let input = Input()
    let output = Output()
    
    private weak var coordinator: RepoListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepoListCoordinator, repository: RepositoryEntity) {
        
    }
}
