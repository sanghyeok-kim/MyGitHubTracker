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
            case .success(let data):
                guard let token = try? JSONDecoder().decode(TokenDTO.self, from: data) else {
                    completion(.failure(NetworkError.decodeError))
                    return
                }
                let accessToken = token.accessToken
                AccessToken.value = accessToken
                
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAndStoreAccessToken(with url: URL) async throws -> TokenDTO {
        let gitHubAuthorization = GitHubAuthorizationEntity(url: url)
        
        let data = try await loginRepository.fetchAccessToken(
            clientID: gitHubAuthorization.clientID,
            clientSecret: gitHubAuthorization.clientSecret,
            tempCode: gitHubAuthorization.tempCode
        )
        
        guard let token = try? JSONDecoder().decode(TokenDTO.self, from: data) else {
            throw NetworkError.decodeError
        }
        
        AccessToken.value = token.accessToken
        return token
    }
    
    func fetchAndStoreAccessToken(with url: URL) -> Single<TokenDTO> {
        let gitHubAuthorization = GitHubAuthorizationEntity(url: url)
        
        return loginRepository.fetchAccessToken(
            clientID: gitHubAuthorization.clientID,
            clientSecret: gitHubAuthorization.clientSecret,
            tempCode: gitHubAuthorization.tempCode
        )
        .decodeMap(TokenDTO.self)
        .do { AccessToken.value = $0.accessToken }
    }
}
