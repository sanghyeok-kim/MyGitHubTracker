//
//  URLDataFetchRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

protocol URLDataFetchRepository {
    func fetch(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> ())
}
