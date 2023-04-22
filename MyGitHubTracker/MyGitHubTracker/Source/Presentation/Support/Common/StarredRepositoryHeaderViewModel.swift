//
//  StarredRepositoryHeaderViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/19.
//

import RxSwift
import RxRelay

final class StarredRepositoryHeaderViewModel: ViewModelType {
    struct Input {
        let showAllButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        
    }
    
    let input = Input()
    let output = Output()
    
    private weak var coordinator: AccountCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator?) {
        self.coordinator = coordinator
        
        // MARK: - Bind Input - showAllButtonDidTap
        
        input.showAllButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                self.coordinator?.coordinate(by: .showAllButtonDidTap)
            }
            .disposed(by: disposeBag)
    }
}
