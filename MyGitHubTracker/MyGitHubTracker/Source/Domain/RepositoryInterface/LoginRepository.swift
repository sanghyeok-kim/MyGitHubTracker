//
//  LoginRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

protocol LoginRepository {
    func buildGitHubAuthorizationURL() -> URL?
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String, completion: @escaping ((Result<TokenDTO, Error>) -> Void))
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String) async throws -> TokenDTO
    func fetchAccessToken(clientID: String, clientSecret: String, tempCode: String) -> Single<String>
}
