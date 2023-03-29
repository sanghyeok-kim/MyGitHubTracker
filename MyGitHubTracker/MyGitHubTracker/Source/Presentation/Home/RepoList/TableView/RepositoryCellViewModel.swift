//
//  RepositoryCellViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import RxSwift
import RxCocoa

final class RepositoryCellViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let name: Driver<String>
        let description: Driver<String?>
        let updatedDate: Driver<String>
        let isPrivate: Driver<Bool>
    }
    
    let input = Input()
    let output: Output
    
    private let repositoryEntity: RepositoryEntity
    private let disposeBag = DisposeBag()
    
    init(repositoryEntity: RepositoryEntity) {
        self.repositoryEntity = repositoryEntity
        
        output = Output(
            name: .just(repositoryEntity.name),
            description: .just(repositoryEntity.description),
            updatedDate: .just(repositoryEntity.updatedDate),
            isPrivate: .just(repositoryEntity.isPrivate)
        )
    }
}
