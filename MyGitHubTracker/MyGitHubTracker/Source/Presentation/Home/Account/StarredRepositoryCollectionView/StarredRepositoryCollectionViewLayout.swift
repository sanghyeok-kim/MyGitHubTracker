//
//  StarredRepositoryCollectionViewLayout.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/18.
//

import RxSwift

protocol CollectionViewLayout {
    func sectionProvider(_ section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}

final class StarredRepositoryCollectionViewLayout: CollectionViewLayout {
    
    var collectionViewSize: CGSize = .zero
    private let headerHeight: CGFloat = 30
    
    private lazy var headerLayoutSize: NSCollectionLayoutSize = {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(collectionViewSize.width),
            heightDimension: .estimated(headerHeight)
        )
        return headerLayoutSize
    }()
    
    private lazy var headerItem: NSCollectionLayoutBoundarySupplementaryItem = {
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        headerItem.pinToVisibleBounds = true
        return headerItem
    }()
    
    private lazy var layoutItem: NSCollectionLayoutItem = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        return layoutItem
    }()
    
    private lazy var layoutGroup: NSCollectionLayoutGroup = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(collectionViewSize.width * 0.7),
            heightDimension: .absolute((collectionViewSize.height - headerHeight) * 0.9)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitems: [layoutItem]
        )
        return layoutGroup
    }()
    
    private lazy var layoutSection: NSCollectionLayoutSection = {
        let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
        sectionLayout.orthogonalScrollingBehavior = .groupPaging
        sectionLayout.contentInsets = NSDirectionalEdgeInsets(
            top: collectionViewSize.height * 0.05,
            leading: .zero,
            bottom: collectionViewSize.height * 0.1,
            trailing: collectionViewSize.width * 0.05
        )
        sectionLayout.interGroupSpacing = 30
        sectionLayout.boundarySupplementaryItems = [headerItem]
        
        return sectionLayout
    }()
    
    func sectionProvider(_ section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        return layoutSection
    }
}
