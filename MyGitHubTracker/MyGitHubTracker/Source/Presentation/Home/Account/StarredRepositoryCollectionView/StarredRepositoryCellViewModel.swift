//
//  StarredRepositoryCellViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/18.
//
//

import RxSwift
import RxRelay

final class StarredRepositoryCellViewModel: ViewModelType {
    struct Input {
        let cellDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let avatarImageURL = BehaviorRelay<URL?>(value: nil)
        let ownerName = BehaviorRelay<String>(value: "")
        let title = BehaviorRelay<String>(value: "")
        let description = BehaviorRelay<String?>(value: nil)
        let starCount = BehaviorRelay<Int>(value: .zero)
    }
    
    struct State {
        let repository: BehaviorRelay<RepositoryEntity>
    }
    
    let input = Input()
    let output = Output()
    let state: State
    
    private weak var coordinator: AccountCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator?, repository: RepositoryEntity) {
        self.coordinator = coordinator
        self.state = State(repository: BehaviorRelay<RepositoryEntity>(value: repository))
        
        state.repository
            .map { $0.avatarImageURL }
            .bind(to: output.avatarImageURL)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.ownerName }
            .bind(to: output.ownerName)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.name }
            .bind(to: output.title)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.description }
            .bind(to: output.description)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.stargazersCount }
            .bind(to: output.starCount)
            .disposed(by: disposeBag)
    }
}
