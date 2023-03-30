//
//  Rx+toastMessageMap.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/30.
//

import RxSwift

extension ObservableType {
    func toastMeessageMap(to toastMessage: ToastError) -> Observable<String> {
        return map { _ in toastMessage.localizedDescription }
    }
}
