//
//  ToastLabel.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import UIKit

final class ToastLabel: RoundedPaddingLabel {
    override init(padding: Padding = .medium) {
        super.init(padding: padding)
        configureUI()
    }
    
    func show(message: String) {
        text = message
        sizeToFit()
        fadeIn(completion: delayedFadeOut)
    }
}

// MARK: - UI Configuration

private extension ToastLabel {
    func configureUI() {
        alpha = .zero
        font = UIFont.systemFont(ofSize: 15)
        textAlignment = .center;
        textColor = UIColor.white
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        numberOfLines = .zero
        lineBreakMode = .byWordWrapping
    }
}

// MARK: - Internal Methods

private extension ToastLabel {
    func fadeIn(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.alpha = 1.0
        }, completion: { _ in
            completion()
        })
    }
    
    func delayedFadeOut() {
        UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseIn, animations: { [weak self] in
            self?.alpha = .zero
        })
    }
}
