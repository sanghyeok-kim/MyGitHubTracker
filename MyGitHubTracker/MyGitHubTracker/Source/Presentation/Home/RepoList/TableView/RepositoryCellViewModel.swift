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
        let description = BehaviorRelay<String?>(value: nil)
        let updatedDate = BehaviorRelay<String>(value: "")
    }
    
    let input = Input()
    let output = Output()
    
    private let repositoryEntity: RepositoryEntity
    private let disposeBag = DisposeBag()
    
    init(repositoryEntity: RepositoryEntity) {
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
            .map { repositoryEntity.updatedDate }
            .bind(to: output.updatedDate)
            .disposed(by: disposeBag)
    }
}
