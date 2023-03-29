//
//  RepositorySection.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/29.
//

import RxDataSources

struct RepositorySection {
    var items: [RepositoryEntity]
}

extension RepositorySection: SectionModelType {
    typealias Item = RepositoryEntity
    
    init(original: RepositorySection, items: [RepositoryEntity]) {
        self = original
        self.items = items
    }
}
