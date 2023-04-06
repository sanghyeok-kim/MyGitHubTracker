//
//  RepositorySearchUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

protocol RepositorySearchUseCase {
    var fetchedUserRepositories: BehaviorRelay<[RepositoryEntity]> { get }
    var errorDidOccur: PublishRelay<ToastError> { get }
    func fetchUserRepositories(perPage: Int, page: Int)
}
