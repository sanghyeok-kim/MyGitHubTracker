//
//  CircularImageView.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import UIKit.UIImageView

final class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = max(frame.width, frame.height) / 2
    }
}
