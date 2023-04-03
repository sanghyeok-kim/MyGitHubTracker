//
//  LoginUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxRelay

protocol LoginUseCase {
    var errorDidOccur: PublishRelay<ToastError> { get }
    var userDidAuthorized: PublishRelay<Void> { get }
    
    func buildGitHubAuthorizationURL() -> URL?
    func fetchAndStoreAccessToken(with url: URL)
}
