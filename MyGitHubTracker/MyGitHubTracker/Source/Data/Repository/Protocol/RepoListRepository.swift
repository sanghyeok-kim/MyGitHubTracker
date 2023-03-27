//
//  RepoListRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

protocol RepoListRepository {
    func fetchRepositories(perPage: Int, page: Int) -> Single<Data>
}
