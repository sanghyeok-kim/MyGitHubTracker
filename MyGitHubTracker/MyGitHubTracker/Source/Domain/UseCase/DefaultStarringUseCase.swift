//
//  DefaultStarringUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift
import RxRelay

final class DefaultStarringUseCase: StarringUseCase {
    
    let isStarred = BehaviorRelay<Bool>(value: false)
    let errorDidOccur = PublishRelay<ToastError>()
    
    @Inject private var starringRepository: StarringRepository
    private let disposeBag = DisposeBag()
    
    func checkRepositoryIsStarred(repositoryOwner: String, repositoryName: String) {
        starringRepository
            .checkRepositoryIsStarred(repositoryOwner: repositoryOwner, repositoryName: repositoryName)
            .do(onError: { error in
                CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
            })
            .subscribe(with: self, onSuccess: { `self`, isStarred in
                self.isStarred.accept(isStarred)
            }, onFailure: { `self`, error in
                self.errorDidOccur.accept(.failToFetchRepositories)
            })
            .disposed(by: disposeBag)
    }
}
