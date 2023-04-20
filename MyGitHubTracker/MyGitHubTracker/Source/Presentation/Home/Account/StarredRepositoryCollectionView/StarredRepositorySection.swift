//
//  StarredRepositorySection.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/18.
//

import RxDataSources

struct StarredRepositorySection {
    var items: [StarredRepositoryCellViewModel]
    var headerViewModel: StarredRepositoryHeaderViewModel
}

extension StarredRepositorySection: SectionModelType {
    typealias Item = StarredRepositoryCellViewModel
    
    init(original: StarredRepositorySection, items: [StarredRepositoryCellViewModel]) {
        self = original
        self.items = items
    }
}
