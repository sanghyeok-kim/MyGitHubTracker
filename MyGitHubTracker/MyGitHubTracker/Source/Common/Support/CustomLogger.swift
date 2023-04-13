//
//  CustomLogger.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import OSLog

struct CustomLogger {
    static func log(message: String, category: OSLog.LogCategory, type: OSLogType = .error) {
        #if DEBUG
        let log = OSLog(subsystem: OSLog.subsystem, category: category.value)
        os_log(type, log: log, "\(message)")
        #endif
    }
    
    static func logDeallocation<T: AnyObject>(object: T) {
        #if DEBUG
        let log = OSLog(subsystem: OSLog.subsystem, category: OSLog.LogCategory.allocation.value)
        os_log(.info, log: log, "\(T.self) deallocated")
        #endif
    }
}
