//
//  RxCollectionViewSectionedReloadDataSource+init.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/18.
//

import RxDataSources

extension RxCollectionViewSectionedReloadDataSource {
    
    typealias CellConfigureAction<Section: SectionModelType, Cell: UICollectionViewCell> = (Cell, Section.Item) -> Void
    
    convenience init<Cell: UICollectionViewCell>(with cellConfigureAction: @escaping CellConfigureAction<Section, Cell>) {
        let configureCell: ConfigureCell = { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else {
                return UICollectionViewCell()
            }
            
            cellConfigureAction(cell, item)
            return cell
        }
        
        self.init(configureCell: configureCell)
    }
}
