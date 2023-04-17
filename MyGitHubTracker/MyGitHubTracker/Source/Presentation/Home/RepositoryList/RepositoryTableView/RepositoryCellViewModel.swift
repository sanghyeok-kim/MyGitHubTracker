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
        let cellDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let name = BehaviorRelay<String>(value: "")
        let visibility = BehaviorRelay<RepositoryVisibility>(value: .public)
        let isStarred = BehaviorRelay<Bool>(value: false)
        let description = BehaviorRelay<String?>(value: nil)
        let starCount = BehaviorRelay<Int>(value: .zero)
        let updatedDate = BehaviorRelay<String>(value: "")
    }
    
    struct State {
        let repository: BehaviorRelay<RepositoryEntity>
    }
    
    let input = Input()
    let output = Output()
    let state: State
    
    @Inject private var starringUseCase: StarringUseCase
    
    private weak var coordinator: RepositoryListCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: RepositoryListCoordinator?, repository: RepositoryEntity) {
        self.coordinator = coordinator
        self.state = State(repository: BehaviorRelay<RepositoryEntity>(value: repository))
        
        // MARK: - Bind State: repository
        
        state.repository
            .map { $0.name }
            .bind(to: output.name)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.isPrivate ? .private : .public }
            .bind(to: output.visibility)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.description }
            .bind(to: output.description)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.stargazersCount }
            .bind(to: output.starCount)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.updatedDate }
            .bind(to: output.updatedDate)
            .disposed(by: disposeBag)
        
        state.repository
            .map { $0.isStarredByUser }
            .bind(to: output.isStarred)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input: cellDidTap
        
        input.cellDidTap
            .withLatestFrom(state.repository)
            .map { RepositoryDetailViewModel(coordinator: coordinator, repository: $0) }
            .do { [weak self] in
                self?.bindState(from: $0)
            }
            .bind {
                coordinator?.coordinate(by: .cellDidTap(viewModel: $0))
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - External Methods

extension RepositoryCellViewModel {
    func cellDidTap() {
        input.cellDidTap.accept(())
    }
}

// MARK: - Binding Other ViewModels

private extension RepositoryCellViewModel {
    func bindState(from detailViewModel: RepositoryDetailViewModel) {
        detailViewModel.state.repository
            .bind(to: state.repository)
            .disposed(by: disposeBag)
    }
}
