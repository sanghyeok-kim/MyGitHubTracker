//
//  RepositoryDetailViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/30.
//

import RxSwift
import RxCocoa
import RxAppState
import RxDataSources
import SnapKit
import Then

final class RepositoryDetailViewController: UIViewController, ViewType {
    
    private lazy var loadingIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
    }
    
    private lazy var userProfileImageView = CircularImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.textColor = .systemGray
    }
    
    private lazy var userProfileStackView = UIStackView().then {
        $0.addArrangedSubviews([userProfileImageView, userNameLabel])
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.numberOfLines = .zero
        $0.lineBreakMode = .byWordWrapping
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.numberOfLines = .zero
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let stargazerView = StargazerView()
    
    private lazy var starsStackView = UIStackView().then {
        let label = UILabel()
        label.text = "stars"
        $0.addArrangedSubviews([stargazerView, label])
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.isHidden = true
    }
    
    private lazy var repositoryStackView = UIStackView().then {
        $0.addArrangedSubviews([titleLabel, descriptionLabel, starsStackView])
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private lazy var starringButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Star"
        configuration.imagePadding = 5
        $0.configuration = configuration
        $0.isHidden = true
    }
    
    private let errorToastMessageLabel = ToastLabel()
    
    @Inject private var imageLoader: ImageLoader
    
    var viewModel: RepositoryDetailViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    func bindInput(to viewModel: RepositoryDetailViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        starringButton.rx.tap
            .bind(to: input.starringButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: RepositoryDetailViewModel) {
        let output = viewModel.output
        
        output.isLoadingIndicatorVisible
            .asDriver()
            .drive(
                loadingIndicator.rx.isAnimating,
                starsStackView.rx.isHidden,
                starringButton.rx.isHidden
            )
            .disposed(by: disposeBag)
        
        output.avatarImageURL
            .asDriver()
            .compactMap { $0 }
            .drive(userProfileImageView.rx.loadImage(using: imageLoader, disposeBag: disposeBag))
            .disposed(by: disposeBag)
        
        output.ownerName
            .asDriver()
            .drive(userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.name
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.description
            .asDriver()
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.starCount
            .asDriver()
            .drive(onNext: stargazerView.set(count:))
            .disposed(by: disposeBag)
        
        output.isStarredByUser
            .asDriver()
            .drive(with: self) { `self`, isStarred in
                self.stargazerView.toggleStarMark(by: isStarred)
                self.toggleStarringButtonStarMark(by: isStarred)
            }
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .asSignal()
            .emit(onNext: errorToastMessageLabel.show(message:))
            .disposed(by: disposeBag)
    }
    
    deinit {
        CustomLogger.logDeallocation(object: self)
    }
}

// MARK: Supporting Methods

private extension RepositoryDetailViewController {
    func toggleStarringButtonStarMark(by isStarred: Bool) {
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 12))
        var imageName: String
        switch isStarred {
        case true:
            imageName = "star.fill"
        case false:
            imageName = "star"
        }
        let image = UIImage(systemName: imageName)?.applyingSymbolConfiguration(imageSymbolConfiguration)
        starringButton.configuration?.image = image
    }
}

// MARK: - UI Configuration

private extension RepositoryDetailViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension RepositoryDetailViewController {
    func layoutUI() {
        view.addSubview(userProfileStackView)
        view.addSubview(repositoryStackView)
        view.addSubview(starringButton)
        view.addSubview(loadingIndicator)
        view.addSubview(errorToastMessageLabel)
        
        userProfileStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        repositoryStackView.snp.makeConstraints { make in
            make.top.equalTo(userProfileStackView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        starringButton.snp.makeConstraints { make in
            make.top.equalTo(repositoryStackView.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.height.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        errorToastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.8)
        }
    }
}
