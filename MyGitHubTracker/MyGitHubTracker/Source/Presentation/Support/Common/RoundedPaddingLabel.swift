//
//  RoundedPaddingLabel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import UIKit

class RoundedPaddingLabel: UILabel {
    
    private let padding: UIEdgeInsets
    
    init(padding: Padding = .medium) {
        self.padding = padding.insets
        super.init(frame: .zero)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
