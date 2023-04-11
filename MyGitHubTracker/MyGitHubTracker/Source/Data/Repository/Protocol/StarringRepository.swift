//
//  StarringRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift
import RxRelay

protocol StarringRepository {
    func checkRepositoryIsStarred(ownerName: String, repositoryName: String) -> Single<Bool>
    func starRepository(ownerName: String, repositoryName: String) -> Completable
    func unstarRepository(ownerName: String, repositoryName: String) -> Completable
}
