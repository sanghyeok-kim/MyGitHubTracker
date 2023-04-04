//
//  DefaultRepoListUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

final class DefaultRepoListUseCase: RepoListUseCase {
    
    let fetchedRepositories = BehaviorRelay<[RepositoryEntity]>(value: [])
    let errorDidOccur = PublishRelay<ToastError>()
    
    @Inject private var repoListRepository: RepoListRepository
    @Inject private var repoListTransformer: AnyTransformer<RepositoryDTO, RepositoryEntity>
    private let disposeBag = DisposeBag()
    
    func fetchRepositories(perPage: Int, page: Int) {
        repoListRepository
            .fetchRepositories(perPage: perPage, page: page)
            .transformMap(repoListTransformer)
            .do(onError: { error in
                CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
            })
            .subscribe(with: self, onSuccess: { `self`, repositories in
                self.fetchedRepositories.accept(repositories)
            }, onFailure: { `self`, error in
                self.errorDidOccur.accept(.failToFetchRepositories)
            })
            .disposed(by: disposeBag)
    }
}
