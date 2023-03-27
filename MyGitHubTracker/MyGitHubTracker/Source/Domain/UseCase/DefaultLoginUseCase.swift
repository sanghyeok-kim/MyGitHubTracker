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
        let clientID = Constant.GitHubClientKey.clientID
        let clientSecret = Constant.GitHubClientKey.clientSecret
        let tempCode = url.absoluteString.components(separatedBy: "code=").last ?? ""
        
        loginRepository.fetchAccessToken(clientID: clientID, clientSecret: clientSecret, tempCode: tempCode) { result in
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
        let clientID = Constant.GitHubClientKey.clientID
        let clientSecret = Constant.GitHubClientKey.clientSecret
        let tempCode = url.absoluteString.components(separatedBy: "code=").last ?? ""
        
        let data = try await loginRepository.fetchAccessToken(clientID: clientID, clientSecret: clientSecret, tempCode: tempCode)
        guard let token = try? JSONDecoder().decode(TokenDTO.self, from: data) else {
            throw NetworkError.decodeError
        }
        AccessToken.value = token.accessToken
        return token
    }
    
    func fetchAndStoreAccessToken(with url: URL) -> Single<TokenDTO> {
        let clientID = Constant.GitHubClientKey.clientID
        let clientSecret = Constant.GitHubClientKey.clientSecret
        let tempCode = url.absoluteString.components(separatedBy: "code=").last ?? ""
        
        return loginRepository.fetchAccessToken(clientID: clientID, clientSecret: clientSecret, tempCode: tempCode)
            .decodeMap(TokenDTO.self)
            .do { AccessToken.value = $0.accessToken }
    }
}
