//
//  ToastLabel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import UIKit

final class ToastLabel: UILabel {
    
    private let padding = UIEdgeInsets(
        top: 8,
        left: 16,
        bottom: 8,
        right: 16
    )
    
    init() {
        super.init(frame: .zero)
        configureUI()
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
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    private func configureUI() {
        alpha = .zero
        font = UIFont.systemFont(ofSize: 15)
        textAlignment = .center;
        textColor = UIColor.white
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    func show(message: String) {
        text = message
        sizeToFit()
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.alpha = 1.0
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseIn, animations: {
                self?.alpha = .zero
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
        }
    }
}
