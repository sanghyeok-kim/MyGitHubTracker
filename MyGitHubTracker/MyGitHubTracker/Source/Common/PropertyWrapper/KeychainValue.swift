//
//  KeychainValue.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation
import KeychainSwift

protocol KeychainStorable: Codable { } // For Type Safety
extension String: KeychainStorable { }
extension Bool: KeychainStorable { }
extension Data: KeychainStorable { }

@propertyWrapper
struct KeychainValue<T: KeychainStorable> {
    let keychain = KeychainSwift()
    let key: String
    let defaultValue: T?
    
    private let serialQueue = DispatchQueue(label: "TokenStorage.serialQueue")
    
    init(_ key: String, defaultValue: T? = nil) {
        keychain.synchronizable = true
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            serialQueue.sync {
                if let data = keychain.getData(key),
                   let value = try? JSONDecoder().decode(T.self, from: data) {
                    return value
                }
                return nil
            }
        }
        set {
            serialQueue.sync {
                if let newValue = newValue,
                   let data = try? JSONEncoder().encode(newValue) {
                    keychain.set(data, forKey: key)
                } else {
                    keychain.delete(key)
                }
            }
        }
    }
}
