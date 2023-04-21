//
//  StarredRepositoryTableViewCell.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/21.
//

import RxSwift
import SnapKit
import Then

final class StarredRepositoryTableViewCell: UITableViewCell, ViewType {
    
    private lazy var avatarImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    private lazy var ownerNameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private lazy var titleStackView = UIStackView().then {
        $0.addArrangedSubviews([ownerNameLabel, descriptionLabel])
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 2
    }
    
    private lazy var starGazerView = StargazerView().then {
        $0.toggleStarMark(by: true)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var ownerInfoStackView = UIStackView().then {
        $0.addArrangedSubviews([avatarImageView, ownerNameLabel])
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.addArrangedSubviews([ownerInfoStackView, titleLabel, descriptionLabel, starGazerView])
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    @Inject private var imageLoader: ImageLoader
    
    var viewModel: StarredRepositoryCellViewModel?
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
    
    func bindInput(to viewModel: StarredRepositoryCellViewModel) {
        let input = viewModel.input
        
    }
    
    func bindOutput(from viewModel: StarredRepositoryCellViewModel) {
        let output = viewModel.output
        
        output.avatarImageURL
            .asDriver()
            .compactMap { $0 }
            .drive(avatarImageView.rx.loadImage(using: imageLoader, disposeBag: disposeBag))
            .disposed(by: disposeBag)
        
        output.ownerName
            .asDriver()
            .drive(ownerNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.title
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.description
            .asDriver()
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.starCount
            .asDriver()
            .drive(onNext: starGazerView.set(count:))
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension StarredRepositoryTableViewCell {
    func configureUI() {
        contentView.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension StarredRepositoryTableViewCell {
    func layoutUI() {
        contentView.addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(16)
        }
    }
}
