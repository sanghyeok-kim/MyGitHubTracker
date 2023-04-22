//
//  Rx+doLogError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import RxSwift
import OSLog

extension ObservableType where Element: Error {
    func doLogError(logType: OSLogType = .error) -> Observable<Element> {
        return self.do { error in
            let errorMessage = error.localizedDescription
            let errorCategory = (error as? OSLoggable)?.category ?? .default
            CustomLogger.log(message: errorMessage, category: errorCategory, type: logType)
        }
    }
}
