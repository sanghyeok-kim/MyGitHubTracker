//
//  DefaultLoginRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultLoginRepository: LoginRepository {
    
    @Inject private var urlSessionNetworkService: EndpointService
    @Inject private var gitHubAuthorizationService: AuthorizationService
    
    func buildGitHubAuthorizationURL() -> URL? {
        return gitHubAuthorizationService.buildAuthorizationURL()
    }
    
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String, completion: @escaping ((Result<TokenDTO, Error>) -> Void)) {
        urlSessionNetworkService.fetchData(endpoint: GitHubAPI.fetchAccessToken(
            clientID: clientID,
            clientSecret: clientSecret,
            tempCode: tempCode)
        ) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let tokenDTO = try JSONDecoder().decode(TokenDTO.self, from: data)
                    completion(.success(tokenDTO))
                } catch {
                    completion(.failure(NetworkError.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String) async throws -> TokenDTO {
        let endpoint = GitHubAPI.fetchAccessToken(clientID: clientID, clientSecret: clientSecret, tempCode: tempCode)
        let data = try await urlSessionNetworkService.fetchData(endpoint: endpoint)
        
        do {
            let tokenDTO = try JSONDecoder().decode(TokenDTO.self, from: data)
            return tokenDTO
        } catch {
            throw NetworkError.decodeError
        }
    }
    
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String) -> Single<TokenDTO> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchAccessToken(
                clientID: clientID,
                clientSecret: clientSecret,
                tempCode: tempCode)
            )
            .decodeMap(TokenDTO.self)
    }
}
