//
//  URLDataUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/21.
//

import RxSwift

protocol URLDataUseCase {
    func fetch(from url: URL?) async throws -> Data
    func fetch(from url: URL?) -> Observable<Data>
    func cancel()
}
