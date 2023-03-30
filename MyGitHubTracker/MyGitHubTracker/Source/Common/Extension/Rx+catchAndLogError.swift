//
//  Rx+catchAndLogError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import RxSwift
import OSLog

extension ObservableType where Element: Error {
    func catchAndLogError(logType: OSLogType) -> Observable<Void> {
        return self.do { error in
            let errorMessage = (error as? OSLoggable)?.logMessage ?? error.localizedDescription
            let errorCategory = (error as? OSLoggable)?.category ?? .default
            
            CustomLogger.log(
                message: errorMessage,
                category: errorCategory,
                type: logType
            )
        }
        .map { _ in }
        .catch { _ in .just(()) }
    }
}
