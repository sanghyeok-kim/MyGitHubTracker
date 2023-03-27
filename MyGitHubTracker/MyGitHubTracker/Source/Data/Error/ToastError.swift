//
//  ToastError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import Foundation

enum ToastError: Error, LocalizedError {
    case failToFetchAccessToken
    
    var errorDescription: String? {
        switch self {
        case .failToFetchAccessToken:
            return "사용자 인증 토큰을 불러오는데 실패했습니다."
        }
    }
}
