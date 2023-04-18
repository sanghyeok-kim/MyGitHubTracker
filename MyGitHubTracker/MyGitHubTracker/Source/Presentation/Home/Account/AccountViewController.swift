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
    }
    
    private lazy var toastMessageLabel = ToastLabel()
    
    @Inject private var imageLoader: ImageLoader
    
    var viewModel: AccountViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    func bindInput(to viewModel: AccountViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: AccountViewModel) {
        let output = viewModel.output
        
        output.loginID
            .asDriver()
            .drive(loginIDLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.avatarImageURL
            .asDriver()
            .compactMap { $0 }
            .drive(avatarImageView.rx.loadImage(using: imageLoader, disposeBag: disposeBag))
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
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.8)
        }
    }
}
