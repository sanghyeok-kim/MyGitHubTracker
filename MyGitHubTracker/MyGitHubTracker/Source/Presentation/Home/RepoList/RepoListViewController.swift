//
//  RepoListViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxAppState

final class RepoListViewController: UIViewController, ViewType {
    
    var viewModel: RepoListViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    func bindInput(to viewModel: RepoListViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        
    }
    
    func bindOutput(from viewModel: RepoListViewModel) {
        let output = viewModel.output
        
        
    }
}

// MARK: - UI Configuration

private extension RepoListViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}


// MARK: - UI Layout

private extension RepoListViewController {
    func layoutUI() {
        
    }
}


