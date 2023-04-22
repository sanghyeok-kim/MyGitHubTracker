//
//  Rx+UITableViewCell.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/21.
//

import RxSwift

extension Reactive where Base: UICollectionViewCell {
    var prepareForReuse: Observable<Void> {
        let targetSelector = #selector(Base.prepareForReuse)
        return sentMessage(targetSelector).map { _ in }
    }
}

extension Reactive where Base: UITableViewCell {
    var prepareForReuse: Observable<Void> {
        let targetSelector = #selector(Base.prepareForReuse)
        return sentMessage(targetSelector).map { _ in }
    }
}
