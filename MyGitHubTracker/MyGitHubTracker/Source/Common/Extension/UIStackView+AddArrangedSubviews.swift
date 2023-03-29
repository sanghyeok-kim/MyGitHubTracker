//
//  UIStackView+addArrangedSubviews.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
