//
//  ShowAllCollectionViewCell.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/18.
//

import RxSwift
import SnapKit
import Then

final class ShowAllCollectionViewCell: UICollectionViewCell {
    private lazy var showMoreButton = PaddingButton(padding: .small).then {
        $0.setTitle("Show All", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .tintColor
    }
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - UI Layout

private extension ShowAllCollectionViewCell {
    func layoutUI() {
        addSubview(showMoreButton)
        
        showMoreButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
