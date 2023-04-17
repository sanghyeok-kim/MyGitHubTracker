//
//  RepositoryVisibility.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/17.
//

import UIKit

enum RepositoryVisibility: String {
    case `public`
    case `private`
    
    var text: String {
        return rawValue
    }
    
    var capitalizedText: String {
        return rawValue.capitalized
    }
    
    var labelBackgroundColor: UIColor {
        switch self {
        case .public:
            return CustomColor.softGreen
        case .private:
            return CustomColor.softRed
        }
    }
}
