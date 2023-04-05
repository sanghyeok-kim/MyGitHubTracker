//
//  RepositoryCellViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import RxSwift
import RxRelay

final class RepositoryCellViewModel: ViewModelType {
    
    struct Input {
        let cellDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        let name = BehaviorRelay<String>(value: "")
        let isPrivate = BehaviorRelay<Bool>(value: false)
        let isStarred = BehaviorRelay<Bool>(value: false)
        let description = BehaviorRelay<String?>(value: nil)
        let starCount = BehaviorRelay<Int>(value: .zero)
        let updatedDate = BehaviorRelay<String>(value: "")
    }
    
    let input = Input()
    let output = Output()
    private let repositoryEntity: RepositoryEntity
    
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: RepoListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepoListCoordinator, repositoryEntity: RepositoryEntity) {
        self.coordinator = coordinator
        self.repositoryEntity = repositoryEntity
        
        input.cellDidLoad
            .map { repositoryEntity.name }
            .bind(to: output.name)
            .disposed(by: disposeBag)
        
        input.cellDidLoad
            .map { repositoryEntity.isPrivate }
            .bind(to: output.isPrivate)
            .disposed(by: disposeBag)
        
        input.cellDidLoad
            .map { repositoryEntity.description }
            .bind(to: output.description)
            .disposed(by: disposeBag)
        
        input.cellDidLoad
            .map { repositoryEntity.stargazersCount }
            .bind(to: output.starCount)
            .disposed(by: disposeBag)
        
        input.cellDidLoad
            .map { repositoryEntity.updatedDate }
            .bind(to: output.updatedDate)
            .disposed(by: disposeBag)
        
        input.cellDidLoad
            .withUnretained(self)
            .bind { `self`, _ in
                self.starringUseCase.checkRepositoryIsStarred(
                    repositoryOwner: repositoryEntity.ownerName,
                    repositoryName: repositoryEntity.name
                )
            }
            .disposed(by: disposeBag)

        starringUseCase.isStarred
            .bind(to: output.isStarred)
            .disposed(by: disposeBag)
        
        input.cellDidLoad
            .map { repositoryEntity.isStarredByUser }
            .bind(to: output.isStarred)
            .disposed(by: disposeBag)
    }
}
    }
}
