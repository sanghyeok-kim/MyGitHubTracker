//
//  HTTPMethod.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    
    var value: String {
        return rawValue.uppercased()
    }
}
