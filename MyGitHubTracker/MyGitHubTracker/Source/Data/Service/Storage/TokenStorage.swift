//
//  TokenStorage.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

final class TokenStorage: TokenStorable {
    
    @KeychainValue(Constant.GitHubAPI.acceseToken) private(set) var accessToken: String?
    
    static let shared = TokenStorage()
    
    private init() { }
    
    func store(value: String) {
        self.accessToken = value
    }
    
    func deleteValue() {
        accessToken = nil
    }
    
    func isStored() -> Bool {
        return self.accessToken != nil ? true : false
    }
}
