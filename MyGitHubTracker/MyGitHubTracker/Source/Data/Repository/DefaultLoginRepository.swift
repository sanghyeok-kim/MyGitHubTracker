//
//  DefaultLoginRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

final class DefaultLoginRepository: LoginRepository {
    
    @Inject private var urlSessionNetworkService: URLSessionNetworkService
    @Inject private var gitHubAuthorizationService: GitHubAuthorizationService
    
    func buildGitHubAuthorizationURL() -> URL? {
        return gitHubAuthorizationService.buildGitHubAuthorizationURL()
    }
    
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        urlSessionNetworkService.fetchData(endpoint: GitHubAPI.fetchAccessToken(
            clientID: clientID,
            clientSecret: clientSecret,
            tempCode: tempCode)
        ) { (result: Result<Data, Error>) in
            completion(result)
        }
    }
    
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String) async throws -> Data {
        let endpoint = GitHubAPI.fetchAccessToken(clientID: clientID, clientSecret: clientSecret, tempCode: tempCode)
        let result = try await urlSessionNetworkService.fetchData(endpoint: endpoint)
        return result
    }
    
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String) -> Single<Data> {
        return urlSessionNetworkService
            .fetchData(endpoint: GitHubAPI.fetchAccessToken(
                clientID: clientID,
                clientSecret: clientSecret,
                tempCode: tempCode)
            )
    }
}
