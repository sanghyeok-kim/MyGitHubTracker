//
//  RxTableViewSectionedReloadDataSource+init.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/29.
//

import RxDataSources

extension RxTableViewSectionedReloadDataSource {
    
    typealias CellConfigureAction<Section: SectionModelType, Cell: UITableViewCell> = (Cell, Section.Item) -> Void
    
    convenience init<Cell: UITableViewCell>(with cellConfigureAction: @escaping CellConfigureAction<Section, Cell>) {
        let configureCell: ConfigureCell = { _, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
                return UITableViewCell()
            }
            
            cellConfigureAction(cell, item)
            return cell
        }
        
        self.init(configureCell: configureCell)
    }
}
