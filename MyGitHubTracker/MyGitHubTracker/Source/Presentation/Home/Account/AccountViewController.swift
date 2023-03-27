//
//  AccountViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxAppState

final class AccountViewController: UIViewController, ViewType {
    
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
        
    }
}

// MARK: - UI Configuration
private extension AccountViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}


// MARK: - UI Layout

private extension AccountViewController {
    func layoutUI() {
        
    }
}
