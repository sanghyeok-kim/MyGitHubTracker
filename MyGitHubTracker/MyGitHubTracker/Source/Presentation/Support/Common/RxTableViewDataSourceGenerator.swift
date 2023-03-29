//
//  RxTableViewDataSourceGenerator.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/29.
//

import RxDataSources


struct RxTableViewSectionedReloadDataSourceGenerator<Section: SectionModelType, Cell: UITableViewCell> {
    
    typealias CellConfigureAction = (Cell, Section.Item) -> Void
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    
    static func generate(with cellConfigureAction: @escaping CellConfigureAction) -> DataSource {
        
        let configureCell: DataSource.ConfigureCell = { _, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
                return UITableViewCell()
            }
            cellConfigureAction(cell, item)
            return cell
        }
        
        return RxTableViewSectionedReloadDataSource<Section>(configureCell: configureCell)
    }
}
