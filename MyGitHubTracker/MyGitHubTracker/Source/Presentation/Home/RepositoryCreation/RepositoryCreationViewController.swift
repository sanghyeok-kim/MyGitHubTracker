//
//  RepositoryCreationViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/16.
//

import RxSwift
import RxCocoa
import SnapKit
import Then

class RepositoryCreationViewController: UIViewController, ViewType {
    
    private lazy var cancelBarButtonItem = UIBarButtonItem(systemItem: .close)
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "Title"
    }
    
    private lazy var titleTextField = UITextField().then {
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartDashesType = .no
        $0.autocorrectionType = .no
        $0.placeholder = "Enter repository title"
        $0.borderStyle = .roundedRect
        $0.becomeFirstResponder()
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "Description (optional)"
    }
    
    private lazy var descriptionTextField = UITextField().then {
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartDashesType = .no
        $0.autocorrectionType = .no
        $0.placeholder = "Enter repository description"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var visibilityLabel = UILabel().then {
        $0.text = "Visibility"
    }
    
    private lazy var publicButton = UIButton().then {
        $0.setTitle("Public", for: .normal)
        $0.backgroundColor = .tintColor
    }
    
    private lazy var privateButton = UIButton().then {
        $0.setTitle("Private", for: .normal)
        $0.backgroundColor = .lightGray
    }
    
    private lazy var visibilityButtonStackView = UIStackView().then {
        $0.addArrangedSubviews([publicButton, privateButton])
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.distribution = .fillEqually
    }
    
    private lazy var titleStackView = UIStackView().then {
        $0.addArrangedSubviews([titleLabel, titleTextField])
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var descriptionStackView = UIStackView().then {
        $0.addArrangedSubviews([descriptionLabel, descriptionTextField])
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var visibilityStackView = UIStackView().then {
        $0.addArrangedSubviews([visibilityLabel, visibilityButtonStackView])
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var repositoryContentsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleStackView,
            descriptionStackView,
            visibilityStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var doneButton = LoadingIndicatorButton().then {
        $0.setOriginTitle("Done", for: .normal)
        $0.setBackgroundColorForState(enabledColor: .darkGray, disabledColor: .lightGray)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    var viewModel: RepositoryCreationViewModel?
    private let disposeBag = DisposeBag()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        bindTextFieldControlEvents()
    }
    
    func bindInput(to viewModel: RepositoryCreationViewModel) {
        let input = viewModel.input
        
        cancelBarButtonItem.rx.tap
            .bind(to: input.cancelButtonDidTap)
            .disposed(by: disposeBag)
        
        titleTextField.rx.textChanged
            .orEmpty
            .bind(to: input.title)
            .disposed(by: disposeBag)
        
        descriptionTextField.rx.text
            .bind(to: input.description)
            .disposed(by: disposeBag)
        
        Observable.merge(
            privateButton.rx.tap.map { true },
            publicButton.rx.tap.map { false }
        )
        .bind(to: input.isPrivate)
        .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind(to: input.doneButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: RepositoryCreationViewModel) {
        let output = viewModel.output
        
        output.isDoneButtonEnabled
            .asDriver()
            .drive(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.repositoryVisibility
            .asDriver()
            .drive(with: self) { `self`, visibility in
                self.changeVisibilityButtonBackgroundColor(by: visibility)
            }
            .disposed(by: disposeBag)
        
        output.isDoneButtonLoading
            .asDriver()
            .drive(onNext: doneButton.showLoadingIndicatorIfNeeded)
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Methods

private extension RepositoryCreationViewController {
    func bindTextFieldControlEvents() {
        titleTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(with: self, onNext: { `self`, _ in
                self.descriptionTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        descriptionTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(with: self, onNext: { `self`, _ in
                self.descriptionTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    func changeVisibilityButtonBackgroundColor(by visibility: RepositoryVisibility) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            switch visibility {
            case .public:
                self?.privateButton.backgroundColor = UIColor.lightGray
                self?.publicButton.backgroundColor = UIColor.tintColor
            case .private:
                self?.privateButton.backgroundColor = UIColor.tintColor
                self?.publicButton.backgroundColor = UIColor.lightGray
            }
        }
    }
}

// MARK: - UI Configuration

private extension RepositoryCreationViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Create Repository"
        navigationItem.rightBarButtonItem = cancelBarButtonItem
    }
}

// MARK: - UI Layout

private extension RepositoryCreationViewController {
    func layoutUI() {
        view.addSubview(repositoryContentsStackView)
        view.addSubview(doneButton)
        
        repositoryContentsStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(visibilityButtonStackView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.height.equalTo(64)
        }
    }
}
