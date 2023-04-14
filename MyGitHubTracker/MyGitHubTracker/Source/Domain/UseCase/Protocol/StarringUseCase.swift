//
//  StarringUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift

protocol StarringUseCase {
    func checkRepositoryIsStarred(ownerName: String, repositoryName: String) -> Observable<Bool>
    func toggleStarringRepository(ownerName: String, repositoryName: String, shouldStar: Bool) -> Completable
}
