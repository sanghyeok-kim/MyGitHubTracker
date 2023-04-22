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
        let cellDidDequeue = PublishRelay<Void>()
        let cellDidTap = PublishRelay<Void>()
        let prepareForReuse = PublishRelay<Void>()
    }
    
    struct Output {
        let avatarImageData = BehaviorRelay<Data?>(value: nil)
        let ownerName = BehaviorRelay<String>(value: "")
        let title = BehaviorRelay<String>(value: "")
        let description = BehaviorRelay<String?>(value: nil)
        let starCount = BehaviorRelay<Int>(value: .zero)
        let showToastMessage = PublishRelay<String>()
    }
    
    struct State {
        let repository: BehaviorRelay<RepositoryEntity>
    }
    
    let input = Input()
    let output = Output()
    let state: State
    
    @Inject private var urlDataUseCase: URLDataUseCase
    
    private weak var coordinator: AccountCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator?, repository: RepositoryEntity) {
        self.coordinator = coordinator
        self.state = State(repository: BehaviorRelay<RepositoryEntity>(value: repository))
        
        // MARK: - Bind Input - cellDidDequeue
        
        let avatarImageData = input.cellDidDequeue
            .withLatestFrom(state.repository)
            .map { $0.avatarImageURL }
            .withUnretained(self)
            .flatMapMaterialized { `self`, url in
                self.urlDataUseCase.fetch(from: url)
            }
            .share()
        
        avatarImageData
            .compactMap { $0.element }
            .bind(to: output.avatarImageData)
            .disposed(by: disposeBag)
        
        avatarImageData
            .compactMap { $0.error }
            .doLogError()
            .toastMeessageMap(to: .failToFetchImageData)
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        // MARK: - Bind Input - prepareForReuse
        
        input.prepareForReuse
            .bind(onNext: urlDataUseCase.cancel)
            .disposed(by: disposeBag)
        
        // MARK: - Bind State - repository
        
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
