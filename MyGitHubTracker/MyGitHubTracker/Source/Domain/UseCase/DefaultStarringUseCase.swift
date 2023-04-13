//
//  DefaultStarringUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift

final class DefaultStarringUseCase: StarringUseCase {
    
    @Inject private var starringRepository: StarringRepository
    
    func checkRepositoryIsStarred(ownerName: String, repositoryName: String) -> Observable<Bool> {
        return starringRepository
            .checkRepositoryIsStarred(ownerName: ownerName, repositoryName: repositoryName)
            .asObservable()
    }
    
    func starRepository(ownerName: String, repositoryName: String) -> Completable {
        return starringRepository
            .starRepository(ownerName: ownerName, repositoryName: repositoryName)
    }
    
    func unstarRepository(ownerName: String, repositoryName: String) -> Completable {
        return starringRepository
            .unstarRepository(ownerName: ownerName, repositoryName: repositoryName)
    }
}
