//
//  StarazerView.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/04.
//

import UIKit

final class StargazerView: UIView {
    
    private lazy var startImageView: UIImageView = {
        let image = UIImage(systemName: Constant.Image.star)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        let imageSize = startImageView.intrinsicContentSize
        let labelTextSize = countLabel.intrinsicContentSize
        
        let width = imageSize.width + labelTextSize.width + 8
        let height = max(imageSize.height, labelTextSize.height)
        
        return CGSize(width: width, height: height)
    }
    
    init() {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Configuration

private extension StargazerView {
    func layoutUI() {
        addSubview(startImageView)
        addSubview(countLabel)
        
        startImageView.translatesAutoresizingMaskIntoConstraints = false
        startImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        startImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        startImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.topAnchor.constraint(equalTo: startImageView.topAnchor).isActive = true
        countLabel.leadingAnchor.constraint(equalTo: startImageView.trailingAnchor, constant: 8).isActive = true
        countLabel.bottomAnchor.constraint(equalTo: startImageView.bottomAnchor).isActive = true
    }
}

// MARK: - Public Methods

extension StargazerView {
    func set(count: Int) {
        countLabel.text = "\(count)"
    }
    
    func toggleStarMark(by isSelected: Bool) {
        switch isSelected {
        case true:
            startImageView.image = UIImage(systemName: Constant.Image.starFill)
        case false:
            startImageView.image = UIImage(systemName: Constant.Image.star)
        }
    }
}
