//
//  Constant.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

enum Constant { }

extension Constant {
    enum Text {
        static let gitHubLogin = "Sign in with GitHub"
        static let repository = "Repsository"
        static let account = "Account"
        static let star = "Star"
        static let stars = "stars"
        static let title = "Title"
        static let enterRepositoryTitle = "Enter repository title"
        static let description = "Description (optional)"
        static let enterRepositoryDescription = "Enter repository description"
        static let visibility = "Visibility"
        static let done = "Done"
        static let createRepository = "Create Repository"
        static let starredRepository = "Starred Repository"
        static let showAll = "Show All"
    }
}

extension Constant {
    enum Image {
        static let gitHubIcon = "ic_github"
        static let starFill = "star.fill"
        static let star = "star"
        static let listBulletRectanglePortrait = "list.bullet.rectangle.portrait"
        static let person = "person"
    }
}

extension Constant {
    enum DateFormat {
        static let iso8601Format = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let userDisplayFormat = "M월 d일, yyyy년"
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
        static let `default` = "Default"
        static let allocation = "Allocation"
        static let network = "Network"
        static let database = "Database"
    }
}
