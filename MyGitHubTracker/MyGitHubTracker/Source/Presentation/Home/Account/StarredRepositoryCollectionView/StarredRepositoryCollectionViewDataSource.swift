//
//  StarredRepositoryCollectionViewDataSource.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/20.
//

import RxDataSources

final class StarredRepositoryCollectionViewDataSource: RxCollectionViewSectionedReloadDataSource<StarredRepositorySection> {
    init() {
        let configureCell: ConfigureCell = { (dataSource, collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StarredRepositoryCollectionViewCell.identifier,
                for: indexPath
            ) as? StarredRepositoryCollectionViewCell else { return UICollectionViewCell() }
            cell.bind(viewModel: item)
            return cell
        }
        
        let configureSupplementaryView: ConfigureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: StarredRepositoryHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? StarredRepositoryHeaderView else { return UICollectionReusableView() }
                
                headerView.bind(viewModel: dataSource.sectionModels[indexPath.section].headerViewModel)
                return headerView
            }
            return UICollectionReusableView()
        }
        
        super.init(configureCell: configureCell, configureSupplementaryView: configureSupplementaryView)
    }
}
