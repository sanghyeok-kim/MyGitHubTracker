//
//  OSLog+LogCategory.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import OSLog

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? ""
    
    enum LogCategory {
        case `default`
        case allocation
        case network
        case database
        
        var value: String {
            switch self {
            case .`default`:
                return Constant.OSLogCategory.`default`
            case .allocation:
                return Constant.OSLogCategory.allocation
            case .network:
                return Constant.OSLogCategory.network
            case .database:
                return Constant.OSLogCategory.database
            }
        }
    }
}
