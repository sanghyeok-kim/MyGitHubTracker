//
//  RepositorySearchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

protocol RepositorySearchRepository {
    func fetchUserRepositories(perPage: Int, page: Int) -> Single<[RepositoryDTO]>
    func fetchRepositoryDetail(ownerName: String, repositoryName: String) -> Single<RepositoryDTO>
}
