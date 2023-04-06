//
//  URLDataService.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

protocol URLDataService {
    func fetchData(from url: URL) async throws -> Data
}
