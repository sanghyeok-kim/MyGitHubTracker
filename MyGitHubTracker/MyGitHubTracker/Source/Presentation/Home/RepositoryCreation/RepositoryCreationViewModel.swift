//
//  RepositoryCreationViewModel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import RxSwift
import RxRelay

final class RepositoryCreationViewModel: ViewModelType {
    
    struct Input {
        let cancelButtonDidTap = PublishRelay<Void>()
        let title = BehaviorRelay<String>(value: "")
        let description = BehaviorRelay<String?>(value: nil)
        let isPrivate = BehaviorRelay<Bool>(value: false)
        let doneButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let isDoneButtonEnabled = BehaviorRelay<Bool>(value: false)
        let repositoryVisibility = BehaviorRelay<RepositoryVisibility>(value: .public)
        let isDoneButtonLoading = BehaviorRelay<Bool>(value: false)
        let showErrorMessage = PublishRelay<String>()
        let repositoryCreationDidFinish = PublishRelay<Void>()
    }
    
    let input = Input()
    let output = Output()
    
    @Inject private var repositoryCreationUseCase: RepositoryCreationUseCase
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: RepositoryListCoordinator?
    
    init(coordinator: RepositoryListCoordinator?) {
        self.coordinator = coordinator
        
        input.cancelButtonDidTap
            .bind {
                coordinator?.coordinate(by: .repositoryCreationDidCancel)
            }
            .disposed(by: disposeBag)
        
        input.title
            .withLatestFrom(output.isDoneButtonLoading) { ($0, $1) }
            .map { !($0.isEmpty || $1) }
            .bind(to: output.isDoneButtonEnabled)
            .disposed(by: disposeBag)
        
        input.isPrivate
            .map { $0 ? .private : .public }
            .bind(to: output.repositoryVisibility)
            .disposed(by: disposeBag)
        
        input.doneButtonDidTap
            .map { false }
            .bind(to: output.isDoneButtonEnabled)
            .disposed(by: disposeBag)
        
        input.doneButtonDidTap
            .map { true }
            .bind(to: output.isDoneButtonLoading)
            .disposed(by: disposeBag)
        
        let repositoryCreationResult = input.doneButtonDidTap
            .withLatestFrom(Observable.combineLatest(input.title, input.description, input.isPrivate))
            .withUnretained(self)
            .flatMapCompletableMaterialized { `self`, repositoryInfo in
                let (title, description, isPrivate) = repositoryInfo
                return self.repositoryCreationUseCase
                    .createRepository(title: title, description: description, isPrivate: isPrivate)
            }
            .share()
        
        repositoryCreationResult
            .compactMap { $0.error }
            .doLogError(logType: .error)
            .toastMeessageMap(to: .failToCreatRepository)
            .bind(to: output.showErrorMessage)
            .disposed(by: disposeBag)
        
        repositoryCreationResult
            .filter { $0.isStopEvent }
            .map { _ in false }
            .bind(to: output.isDoneButtonLoading)
            .disposed(by: disposeBag)
        
        repositoryCreationResult
            .filter { $0.isStopEvent }
            .map { _ in true }
            .bind(to: output.isDoneButtonEnabled)
            .disposed(by: disposeBag)
        
        repositoryCreationResult
            .compactMap { $0.element }
            .bind {
                coordinator?.coordinate(by: .repositoryDidCreate)
            }
            .disposed(by: disposeBag)
        
        repositoryCreationResult
            .compactMap { $0.element }
            .bind(to: output.repositoryCreationDidFinish)
            .disposed(by: disposeBag)
    }
}
