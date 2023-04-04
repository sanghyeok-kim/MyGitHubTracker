//
//  OSLoggable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/30.
//

import Foundation
import OSLog

protocol OSLoggable {
    var category: OSLog.LogCategory { get }
}
