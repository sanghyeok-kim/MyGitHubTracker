//
//  DefaultTokenRepository.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/11.
//

import Foundation

final class DefaultTokenRepository: TokenRepository {
    
    @Inject private var tokenStorage: TokenStorable
    
    func store(value: String) {
        tokenStorage.store(value: value)
    }
    
    func deleteValue() {
        tokenStorage.deleteValue()
    }
    
    func isStored() -> Bool {
        return tokenStorage.isStored()
    }
}
