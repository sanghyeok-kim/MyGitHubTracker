//
//  DefaultRepositorySearchUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class DefaultRepositorySearchUseCase: RepositorySearchUseCase {
    
    let fetchedUserRepositories = BehaviorRelay<[RepositoryEntity]>(value: [])
    let errorDidOccur = PublishRelay<ToastError>()
    
    @Inject private var repositoryListRepository: RepositorySearchRepository
    @Inject private var repositoryTransformer: AnyTransformer<RepositoryDTO, RepositoryEntity>
    private let disposeBag = DisposeBag()
    
    func fetchUserRepositories(perPage: Int, page: Int) {
        repositoryListRepository
            .fetchUserRepositories(perPage: perPage, page: page)
            .transformMap(repositoryTransformer)
            .do(onError: { error in
                CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
            })
            .subscribe(with: self, onSuccess: { `self`, repositories in
                self.fetchedUserRepositories.accept(repositories)
            }, onFailure: { `self`, error in
                self.errorDidOccur.accept(.failToFetchRepositories)
            })
            .disposed(by: disposeBag)
    }
}
