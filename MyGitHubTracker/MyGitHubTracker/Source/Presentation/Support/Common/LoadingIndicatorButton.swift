//
//  LoadingIndicatorButton.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import UIKit.UIButton

final class LoadingIndicatorButton: UIButton {
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private var originTitle: String?
    private var enabledColor: UIColor?
    private var disabledColor: UIColor?
    
    override var isEnabled: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    
    init() {
        super.init(frame: .zero)
        addSubview(activityIndicator)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}

// MARK: - Public Methods

extension LoadingIndicatorButton {
    func setOriginTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        originTitle = title
    }
    
    func setBackgroundColorForState(enabledColor: UIColor?, disabledColor: UIColor?) {
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
    }
    
    func showLoadingIndicatorIfNeeded(_ shouldAnimate: Bool) {
        switch shouldAnimate {
        case true:
            showLoading()
        case false:
            hideLoading()
        }
    }
}

// MARK: - Supporting Methods

private extension LoadingIndicatorButton {
    func updateButtonAppearance() {
        if isEnabled {
            self.backgroundColor = enabledColor
            self.layer.borderColor = enabledColor?.cgColor
        } else {
            self.backgroundColor = disabledColor
            self.layer.borderColor = disabledColor?.cgColor
        }
    }
    
    func showLoading() {
        setTitle(nil, for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        setTitle(originTitle, for: .normal)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
