//
//  RepoListViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxAppState
import RxDataSources
import Then
import SnapKit

final class RepoListViewController: UIViewController, ViewType {
    
    private lazy var repositoryTableViewDataSource: RxTableViewSectionedReloadDataSource<RepositorySection> = {
        return .init { (cell: RepositoryViewCell, cellViewModel: RepositoryCellViewModel) in
            cell.bind(viewModel: cellViewModel)
        }
    }()
    
    private lazy var repositoryTableView = UITableView().then {
        $0.estimatedRowHeight = 120
        $0.rowHeight = UITableView.automaticDimension
        $0.register(RepositoryViewCell.self, forCellReuseIdentifier: RepositoryViewCell.identifier)
    }
    
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
        
        output.repositoryCellViewModels
            .asDriver()
            .map { [RepositorySection(items: $0)] }
            .drive(repositoryTableView.rx.items(dataSource: repositoryTableViewDataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension RepoListViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Repository"
    }
}

// MARK: - UI Layout

private extension RepoListViewController {
    func layoutUI() {
        view.addSubview(repositoryTableView)
        
        repositoryTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
