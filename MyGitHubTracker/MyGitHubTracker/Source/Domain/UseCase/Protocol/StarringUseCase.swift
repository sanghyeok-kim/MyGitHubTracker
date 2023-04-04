//
//  StarringUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import RxSwift
import RxRelay

protocol StarringUseCase {
    var isStarred: BehaviorRelay<Bool> { get }
    var errorDidOccur: PublishRelay<ToastError> { get }
    func checkRepositoryIsStarred(repositoryOwner: String, repositoryName: String)
}
