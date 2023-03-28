//
//  Padding.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import UIKit

enum Padding {
    case small
    case medium
    case large
    
    var insets: UIEdgeInsets {
        switch self {
        case .small:
            return UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        case .medium:
            return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        case .large:
            return UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        }
    }
}
