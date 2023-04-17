//
//  RepositoryCreationRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/17.
//

import RxSwift

protocol RepositoryCreationRepository {
    func createRepository(title: String, description: String?, isPrivate: Bool) -> Completable
}
