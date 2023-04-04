//
//  NetworkResult.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import Foundation

struct NetworkResult {
    let data: Data?
    let response: HTTPURLResponse
    
    var statusCode: Int {
        return response.statusCode
    }
}
