//
//  StarredRepositoryHeaderView.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/18.
//

import RxSwift
import SnapKit
import Then

final class StarredRepositoryHeaderView: UICollectionReusableView, ViewType {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "Starred Repository"
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var showAllButton = PaddingButton(padding: .small).then {
        $0.setTitle("Show All", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .tintColor
    }
    
    var viewModel: StarredRepositoryHeaderViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindInput(to viewModel: StarredRepositoryHeaderViewModel) {
        let input = viewModel.input
        
        
    }
    
    func bindOutput(from viewModel: StarredRepositoryHeaderViewModel) {
        
    }
}

// MARK: - UI Layout

private extension StarredRepositoryHeaderView {
    func layoutUI() {
        addSubview(titleLabel)
        addSubview(showAllButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        showAllButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
