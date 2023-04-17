//
//  DefaultRepositoryCreationUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import RxSwift

final class DefaultRepositoryCreationUseCase: RepositoryCreationUseCase {
    
    @Inject private var repositoryCreationRepository: RepositoryCreationRepository
    
    func createRepository(title: String, description: String?, isPrivate: Bool) -> Completable {
        return repositoryCreationRepository
            .createRepository(title: title, description: description, isPrivate: isPrivate)
    }
}
