//
//  Bundle+GitHubClientKey.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

extension Bundle {
    func object(forGitHubClientKeyDictionaryKey key: String) -> Any? {
        guard let gitHubClientInfoFile = Bundle.main.path(
            forResource: Constant.GitHubClientKey.fileName,
            ofType: Constant.GitHubClientKey.fileExtension
        ), let resource = NSDictionary(contentsOfFile: gitHubClientInfoFile) else { return nil }
        return resource[key]
    }
}
