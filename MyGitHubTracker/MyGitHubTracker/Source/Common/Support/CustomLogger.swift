//
//  CustomLogger.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import OSLog

struct CustomLogger {
    static func log(message: String, category: OSLog.LogCategory, type: OSLogType = .default) {
        #if DEBUG
        let log = OSLog(subsystem: OSLog.subsystem, category: category.value)
        os_log(type, log: log, "\(message)")
        #endif
    }
}
