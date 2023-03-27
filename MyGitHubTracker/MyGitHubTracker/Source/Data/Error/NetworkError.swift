//
//  NetworkError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case objectDeallocated
    case invalidURL
    case invalidResponse
    case invalidStatusCode(code: Int)
    case invalidResponseData
    case invalidRequest
    case decodeError
    case errorDetected(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .objectDeallocated:
            return "Object Deallocated."
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invaild response."
        case .invalidStatusCode(let code):
            return "Invalid status code: \(code)"
        case .invalidResponseData:
            return "Invalid response data."
        case .invalidRequest:
            return "Invalid request."
        case .decodeError:
            return "Fail to decode."
        case .errorDetected(let error):
            return "Error detected: \(error.localizedDescription)"
        }
    }
}
