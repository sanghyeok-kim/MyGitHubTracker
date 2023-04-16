//
//  RepositoryDetailUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import RxSwift

protocol RepositoryDetailUseCase {
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) -> Observable<RepositoryEntity>
}
