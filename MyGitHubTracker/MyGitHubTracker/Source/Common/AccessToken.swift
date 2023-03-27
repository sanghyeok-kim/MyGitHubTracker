//
//  AccessToken.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

struct AccessToken {
    @KeychainValue(Constant.GitHubAPI.acceseToken) static var value: String?
    
    static func isStored() -> Bool {
        return value != nil ? true : false
    }
    
    static func deleteKey() {
        value = nil
    }
}
