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
    
    func toggleStarringRepository(ownerName: String, repositoryName: String, shouldStar: Bool) -> Completable {
        switch shouldStar {
        case true:
            return starringRepository
                .unstarRepository(ownerName: ownerName, repositoryName: repositoryName)
        case false:
            return starringRepository
                .starRepository(ownerName: ownerName, repositoryName: repositoryName)
        }
    }
}
