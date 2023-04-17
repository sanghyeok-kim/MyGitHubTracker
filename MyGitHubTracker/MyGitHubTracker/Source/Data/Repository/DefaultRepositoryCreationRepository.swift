//
//  DefaultRepositoryCreationRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/17.
//

import RxSwift

final class DefaultRepositoryCreationRepository: RepositoryCreationRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    
    func createRepository(title: String, description: String?, isPrivate: Bool) -> Completable {
        let repositoryCreationDTO = RepositoryCreationDTO(name: title, description: description, private: isPrivate)
        return urlSessionNetworkService
               .fetchStatusCode(endpoint: GitHubAPI.createRepository, with: repositoryCreationDTO)
               .asCompletableForStatusCode(expected: 201)
    }
}
