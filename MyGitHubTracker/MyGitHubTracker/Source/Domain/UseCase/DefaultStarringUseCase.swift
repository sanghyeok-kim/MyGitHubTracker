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
    
    func checkRepositoryIsStarred(ownerName: String, repositoryName: String) -> Observable<Bool> {
        return starringRepository
            .checkRepositoryIsStarred(ownerName: ownerName, repositoryName: repositoryName)
            .do(onError: { [weak self] error in
                CustomLogger.log(message: error.localizedDescription, category: .network, type: .error)
                self?.errorDidOccur.accept(.failToFetchRepositories)
            })
            .asObservable()
    }
}
