//
//  Constant.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

enum Constant { }

extension Constant {
    enum UIStrings {
        static let gitHubLogin = "Sign in with GitHub"
    }
}

extension Constant {
    enum ImageName {
        static let gitHubIcon = "ic_github"
    }
}

extension Constant {
    enum GitHubAPI {
        static let acceseToken = "AccessToken"
    }
}

extension Constant {
    enum GitHubClientKey {
        static let fileExtension = "plist"
        static let fileName = "GitHubClientKey"
        static let clientID = Bundle.main.object(forGitHubClientKeyDictionaryKey: "ClientID") as? String ?? ""
        static let clientSecret = Bundle.main.object(forGitHubClientKeyDictionaryKey: "ClientSecret") as? String ?? ""
    }
}

extension Constant {
    enum OSLogCategory {
        static let defaultCategory = "Default"
        static let allocation = "Allocation"
        static let networkCategory = "Network"
        static let databaseCategory = "Database"
    }
}
