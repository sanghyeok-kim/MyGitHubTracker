//
//  RepositoryTableViewCell.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/28.
//

import RxSwift
import RxCocoa
import SnapKit
import Then

final class RepositoryTableViewCell: UITableViewCell, ViewType {
    
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
    
    private lazy var starGazerView = StargazerView().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var updatedDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    var viewModel: RepositoryCellViewModel?
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
        
        output.starCount
            .asDriver()
            .drive(onNext: starGazerView.set(count:))
            .disposed(by: disposeBag)
        
        output.updatedDate
            .asDriver()
            .compactMap { "Last updated on \($0)" }
            .drive(updatedDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.visibility
            .asDriver()
            .map { $0.text }
            .drive(accessLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.visibility
            .asDriver()
            .map { $0.labelBackgroundColor }
            .drive(accessLabel.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.isStarred
            .asDriver()
            .drive(onNext: starGazerView.toggleStarMark)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension RepositoryTableViewCell {
    func configureUI() {
        
    }
}

// MARK: - UI Layout

private extension RepositoryTableViewCell {
    func layoutUI() {
        contentView.addSubview(titleStackView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starGazerView)
        contentView.addSubview(updatedDateLabel)
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        starGazerView.snp.makeConstraints { make in
            make.centerY.equalTo(updatedDateLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        updatedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }
}
