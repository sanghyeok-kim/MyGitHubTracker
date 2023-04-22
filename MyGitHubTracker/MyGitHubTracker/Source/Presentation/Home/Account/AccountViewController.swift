//
//  AccountViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxAppState
import RxDataSources
import Then
import SnapKit

final class AccountViewController: UIViewController, ViewType {
    
    private lazy var avatarImageView = CircularImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
    }
    
    private lazy var loginIDLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
    }
    
    private lazy var followersCountLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var followingCountLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16)
    }
    
    private lazy var followersStackView = UIStackView().then {
        $0.addArrangedSubviews([followersCountLabel, followingCountLabel])
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    private lazy var userInfoStackView = UIStackView().then {
        $0.addArrangedSubviews([nameLabel, loginIDLabel, followersStackView])
        $0.axis = .vertical
        $0.spacing = 8
        $0.setCustomSpacing(16, after: loginIDLabel)
        $0.isHidden = true
    }
    
    private lazy var accountInfoLoadingIndicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.hidesWhenStopped = true
    }
    
    private lazy var starredRepositoryCollectionViewDataSource = StarredRepositoryCollectionViewDataSource()
    private lazy var starredRepositoryCollectionViewLayout = StarredRepositoryCollectionViewLayout()
    private lazy var starredRepositoryCompositionalLayout: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let compositionalLayout = UICollectionViewCompositionalLayout(
            sectionProvider: starredRepositoryCollectionViewLayout.sectionProvider,
            configuration: configuration
        )
        return compositionalLayout
    }()
    private lazy var starredRepositoryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: starredRepositoryCompositionalLayout
    ).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(
            StarredRepositoryCollectionViewCell.self,
            forCellWithReuseIdentifier: StarredRepositoryCollectionViewCell.identifier
        )
        $0.register(
            StarredRepositoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StarredRepositoryHeaderView.reuseIdentifier
        )
    }
    
    private lazy var toastMessageLabel = ToastLabel()
    
    var viewModel: AccountViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        starredRepositoryCollectionViewLayout.collectionViewSize = starredRepositoryCollectionView.bounds.size
    }
    
    func bindInput(to viewModel: AccountViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: AccountViewModel) {
        let output = viewModel.output
        
        output.starredRepositorySections
            .asDriver()
            .drive(starredRepositoryCollectionView.rx.items(dataSource: starredRepositoryCollectionViewDataSource))
            .disposed(by: disposeBag)
        
        output.loginID
            .asDriver()
            .drive(loginIDLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.avatarImageData
            .asDriver()
            .compactMap { $0 }
            .drive(avatarImageView.rx.imageData)
            .disposed(by: disposeBag)
        
        output.gitHubURL
            .asDriver()
            .compactMap { $0 }
            .drive()
            .disposed(by: disposeBag)
        
        output.name
            .asDriver()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.followersCount
            .asDriver()
            .map { "\($0) followers" }
            .drive(followersCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.followingCount
            .asDriver()
            .map { "\($0) following" }
            .drive(followingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoadingIndicatorVisible
            .asDriver()
            .drive(accountInfoLoadingIndicator.rx.isAnimating, userInfoStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showToastMessage
            .asSignal()
            .emit(onNext: toastMessageLabel.show(message:))
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension AccountViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Account"
    }
}

// MARK: - UI Layout

private extension AccountViewController {
    func layoutUI() {
        view.addSubview(avatarImageView)
        view.addSubview(userInfoStackView)
        view.addSubview(accountInfoLoadingIndicator)
        view.addSubview(starredRepositoryCollectionView)
        view.addSubview(toastMessageLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        userInfoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(32)
        }
        
        accountInfoLoadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(userInfoStackView)
        }
        
        starredRepositoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(156)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(124)
        }
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.8)
        }
    }
}
