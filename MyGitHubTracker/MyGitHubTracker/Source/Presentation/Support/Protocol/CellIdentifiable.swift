//
//  CellIdentifiable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import UIKit

protocol CellIdentifiable { }

extension CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellIdentifiable { }
extension UICollectionViewCell: CellIdentifiable { }
