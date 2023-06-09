//
//  ToastError.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import Foundation

enum ToastMessage {
    case failToFetchAccessToken
    case failToFetchRepositories
    case failToFetchUserInformation
    case failToStarring
    case failToCreatRepository
    case repositoryCreated
    case failToFetchImageData
    
    var localized: String { // TODO: Localizing
        switch self {
        case .failToFetchAccessToken:
            return "사용자 인증 토큰을 불러오는 데 실패했습니다."
        case .failToFetchRepositories:
            return "사용자 레포지토리를 불러오는 데 실패했습니다."
        case .failToFetchUserInformation:
            return "사용자 정보를 불러오는 데 실패했습니다."
        case .failToStarring:
            return "Star 정보를 변경하는 데 실패했습니다."
        case .failToCreatRepository:
            return "레포지토리를 생성하는 데 실패했습니다."
        case .repositoryCreated:
            return "레포지토리가 생성되었습니다."
        case .failToFetchImageData:
            return "이미지 데이터를 불러오는 데 실패했습니다."
        }
    }
}
