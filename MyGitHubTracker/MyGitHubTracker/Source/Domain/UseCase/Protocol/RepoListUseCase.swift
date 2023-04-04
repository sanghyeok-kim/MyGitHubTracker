//
//  RepoListUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

protocol RepoListUseCase {
    var fetchedRepositories: BehaviorRelay<[RepositoryEntity]> { get }
    var errorDidOccur: PublishRelay<ToastError> { get }
    func fetchRepositories(perPage: Int, page: Int)
}
