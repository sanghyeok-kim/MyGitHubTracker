//
//  StarringUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift

protocol StarringUseCase {
    func checkRepositoryIsStarred(ownerName: String, repositoryName: String) -> Observable<Bool>
    func starRepository(ownerName: String, repositoryName: String) -> Completable
    func unstarRepository(ownerName: String, repositoryName: String) -> Completable
}
