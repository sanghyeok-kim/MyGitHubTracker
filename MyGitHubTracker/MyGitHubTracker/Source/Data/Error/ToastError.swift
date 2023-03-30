//
//  ToastError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import Foundation

enum ToastError: LocalizedError {
    case failToFetchAccessToken
    case failToFetchRepositories
    case failToFetchUserInformation
    
    var errorDescription: String? {
        switch self {
        case .failToFetchAccessToken:
            return "사용자 인증 토큰을 불러오는 데 실패했습니다."
        case .failToFetchRepositories:
            return "사용자 레포지토리를 불러오는 데 실패했습니다."
        case .failToFetchUserInformation:
            return "사용자 정보를 불러오는 데 실패했습니다."
        }
    }
}
