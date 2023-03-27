//
//  RepoListUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

protocol RepoListUseCase {
    func fetchRepositories(perPage: Int, page: Int) -> Single<[RepositoryEntity]>
}
