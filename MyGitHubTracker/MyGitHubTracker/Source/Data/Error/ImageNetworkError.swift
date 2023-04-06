//
//  ImageNetworkError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

enum ImageNetworkError: LocalizedError {
    case errorDetected(error: Error)
    case invalidFileLocation
    
    var errorDescription: String? {
        switch self {
        case .errorDetected(let error):
            return "Error detected: \(error.localizedDescription)"
        case .invalidFileLocation:
            return "Invalid File Location"
        }
    }
}
