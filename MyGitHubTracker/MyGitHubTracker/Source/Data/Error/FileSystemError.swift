//
//  FileSystemError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/10.
//

import Foundation
import OSLog

enum FileSystemError: LocalizedError {
    case errorDetected(error: Error)
    case objectDeallocated
    case invalidFilePath
    case dataNotFound
    
    var errorDescription: String? {
        switch self {
        case .errorDetected(let error):
            return "Error detected: \(error.localizedDescription)"
        case .objectDeallocated:
            return "Object Deallocated."
        case .invalidFilePath:
            return "Invalid File Path"
        case .dataNotFound:
            return "Fail to Find Data"
        }
    }
}

extension FileSystemError: OSLoggable {
    var category: OSLog.LogCategory {
        return .database
    }
}
