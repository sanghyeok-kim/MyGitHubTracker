//
//  DefaultLoginUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultLoginUseCase: LoginUseCase {
    
    @Inject private var loginRepository: LoginRepository
    
    func buildGitHubAuthorizationURL() -> URL? {
        return loginRepository.buildGitHubAuthorizationURL()
    }
    
    func fetchAndStoreAccessToken(with url: URL, completion: @escaping (Result<TokenDTO, Error>) -> Void) {
        let gitHubAuthorization = GitHubAuthorizationEntity(url: url)
        
        loginRepository.fetchAccessToken(
            clientID: gitHubAuthorization.clientID,
            clientSecret: gitHubAuthorization.clientSecret,
            tempCode: gitHubAuthorization.tempCode
        ) { result in
            switch result {
            case .success(let tokenDTO):
                let accessToken = tokenDTO.accessToken
                AccessToken.value = accessToken
                completion(.success(tokenDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAndStoreAccessToken(with url: URL) async throws -> TokenDTO {
        let gitHubAuthorization = GitHubAuthorizationEntity(url: url)
        
        let tokenDTO = try await loginRepository.fetchAccessToken(
            clientID: gitHubAuthorization.clientID,
            clientSecret: gitHubAuthorization.clientSecret,
            tempCode: gitHubAuthorization.tempCode
        )
        AccessToken.value = tokenDTO.accessToken
        return tokenDTO
    }
    
    func fetchAndStoreAccessToken(with url: URL) -> Single<TokenDTO> {
        let gitHubAuthorization = GitHubAuthorizationEntity(url: url)
        
        return loginRepository
            .fetchAccessToken(
                clientID: gitHubAuthorization.clientID,
                clientSecret: gitHubAuthorization.clientSecret,
                tempCode: gitHubAuthorization.tempCode
            )
            .do { AccessToken.value = $0.accessToken }
    }
}
