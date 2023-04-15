//
//  TokenStorable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/11.
//

import Foundation

protocol TokenStorable {
    func store(value: String)
    func deleteValue()
    func isStored() -> Bool
}
