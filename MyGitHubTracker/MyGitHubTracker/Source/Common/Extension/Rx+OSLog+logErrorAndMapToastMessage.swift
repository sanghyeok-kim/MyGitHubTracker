//
//  Rx+OSLog+logErrorAndMapToastMessage.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import RxSwift
import OSLog

extension ObservableType where Element: Error {
    func logErrorAndMapToastMessage(to toastError: ToastError, logCategory: OSLog.LogCategory) -> Observable<String> {
        return self
            .do(onNext: { error in
                CustomLogger.log(
                    message: error.localizedDescription,
                    category: logCategory,
                    type: .error
                )
            })
            .compactMap { _ in toastError.errorDescription }
    }
}
