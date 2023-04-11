//
//  RepositorySearchUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

protocol RepositorySearchUseCase {
    func fetchUserRepositories(perPage: Int, page: Int) -> Observable<[RepositoryEntity]>
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) -> Observable<RepositoryEntity>
}
