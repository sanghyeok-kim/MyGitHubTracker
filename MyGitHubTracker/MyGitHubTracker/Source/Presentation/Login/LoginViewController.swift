//
//  LoginViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxCocoa
import SnapKit
import Then

class LoginViewController: UIViewController, ViewType {
    
    private lazy var gitHubLoginButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: Constant.Image.gitHubIcon)
        configuration.title = Constant.Text.gitHubLogin
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.cornerStyle = .medium
        $0.configuration = configuration
    }
    
    private let toastMessageLabel = ToastLabel()
    
    var viewModel: LoginViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    func bindInput(to viewModel: LoginViewModel) {
        let input = viewModel.input
        
        gitHubLoginButton.rx.tap
            .bind(to: input.gitHubLoginButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: LoginViewModel) {
        let output = viewModel.output
        
        output.showToastMessage
            .asSignal()
            .emit(onNext: toastMessageLabel.show)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension LoginViewController {
    func layoutUI() {
        view.addSubview(gitHubLoginButton)
        view.addSubview(toastMessageLabel)
        
        gitHubLoginButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.8)
        }
    }
}
