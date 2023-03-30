//
//  RepositoryViewCell.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import RxSwift
import RxCocoa
import SnapKit
import Then

final class RepositoryViewCell: UITableViewCell, ViewType {
    
    private lazy var accessLabel = RoundedPaddingLabel(padding: .small).then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private lazy var titleStackView = UIStackView().then {
        $0.addArrangedSubviews([accessLabel, nameLabel])
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 2
    }
    
    private lazy var updatedDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    var viewModel: RepositoryCellViewModel?
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindInput(to viewModel: RepositoryCellViewModel) {
        let input = viewModel.input
        
        defer { input.cellDidLoad.accept(()) }
    }
    
    func bindOutput(from viewModel: RepositoryCellViewModel) {
        let output = viewModel.output
        
        output.name
            .asDriver()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.description
            .asDriver()
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.updatedDate
            .asDriver()
            .compactMap { "Last updated on \($0)" }
            .drive(updatedDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isPrivate
            .asDriver()
            .map { $0 ? "private" : "public" }
            .drive(accessLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isPrivate
            .asDriver()
            .map { $0 ? CustomColor.softRed : CustomColor.softGreen }
            .drive(accessLabel.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}


// MARK: - UI Configuration

private extension RepositoryViewCell {
    func configureUI() {
        
    }
}

// MARK: - UI Layout

private extension RepositoryViewCell {
    func layoutUI() {
        contentView.addSubview(titleStackView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(updatedDateLabel)
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        updatedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }

}
