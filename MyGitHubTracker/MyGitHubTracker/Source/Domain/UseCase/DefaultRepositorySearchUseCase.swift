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
    let fetchedRepositoriyDetail = PublishRelay<RepositoryEntity>()
    let errorDidOccur = PublishRelay<ToastError>()
    
    @Inject private var repositorySearchRepository: RepositorySearchRepository
    @Inject private var repositoryTransformer: AnyTransformer<RepositoryDTO, RepositoryEntity>
    private let disposeBag = DisposeBag()
    
    func fetchUserRepositories(perPage: Int, page: Int) {
        repositorySearchRepository
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
    
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) {
        repositorySearchRepository
            .fetchRepositoryDetail(ownerName: ownerName, repositoryName: repositoryName)
            .transformMap(repositoryTransformer)
            .do(onError: { error in
                CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
            })
            .subscribe(with: self, onSuccess: { `self`, repository in
                self.fetchedRepositoriyDetail.accept(repository)
            }, onFailure: { `self`, error in
                self.errorDidOccur.accept(.failToFetchRepositories)
            })
            .disposed(by: disposeBag)
    }
}
