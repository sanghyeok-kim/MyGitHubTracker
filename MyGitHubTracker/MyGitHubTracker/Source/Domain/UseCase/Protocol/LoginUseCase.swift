//
//  LoginUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift

protocol LoginUseCase {
    func buildGitHubAuthorizationURL() -> URL?
    func fetchAndStoreAccessToken(with url: URL, completion: @escaping (Result<TokenDTO, Error>) -> Void)
    func fetchAndStoreAccessToken(with url: URL) async throws -> TokenDTO
    func fetchAndStoreAccessToken(with url: URL) -> Single<TokenDTO>
}
