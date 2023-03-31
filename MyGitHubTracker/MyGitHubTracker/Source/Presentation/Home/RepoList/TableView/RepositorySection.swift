//
//  RepositorySection.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/29.
//

import RxDataSources

struct RepositorySection {
    var items: [RepositoryCellViewModel]
}

extension RepositorySection: SectionModelType {
    typealias Item = RepositoryCellViewModel
    
    init(original: RepositorySection, items: [RepositoryCellViewModel]) {
        self = original
        self.items = items
    }
}
