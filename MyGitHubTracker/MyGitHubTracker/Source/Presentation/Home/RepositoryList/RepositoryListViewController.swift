//
//  RepositoryListViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import RxSwift
import RxAppState
import RxCocoa
import RxDataSources
import Then
import SnapKit

final class RepositoryListViewController: UIViewController, ViewType {
    
    private lazy var repositoryRefreshControll = UIRefreshControl()
    
    private lazy var createRepositoryBarButtonItem = UIBarButtonItem(systemItem: .add)
    
    private lazy var loadingIndicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.hidesWhenStopped = true
    }
    
    private lazy var repositoryTableViewDataSource: RxTableViewSectionedReloadDataSource<RepositorySection> = {
        return .init { (cell: RepositoryViewCell, cellViewModel: RepositoryCellViewModel) in
            cell.bind(viewModel: cellViewModel)
        }
    }()
    
    private lazy var repositoryTableView = UITableView().then {
        $0.refreshControl = repositoryRefreshControll
        $0.estimatedRowHeight = 120
        $0.rowHeight = UITableView.automaticDimension
        $0.register(RepositoryViewCell.self, forCellReuseIdentifier: RepositoryViewCell.identifier)
        $0.tableFooterView = repositoryTableFooterLoadingView
    }
    
    private lazy var repositoryTableFooterLoadingView = LoadingIndicatorView().then {
        $0.frame.size.height = 120
    }
    
    private lazy var errorToastMessageLabel = ToastLabel()
    
    var viewModel: RepositoryListViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    func bindInput(to viewModel: RepositoryListViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        createRepositoryBarButtonItem.rx.tap
            .bind(to: input.createRepositoryButtonDidTap)
            .disposed(by: disposeBag)
        
        repositoryRefreshControll.rx.controlEvent(.valueChanged)
            .bind(to: input.tableViewDidRefresh)
            .disposed(by: disposeBag)
        
        repositoryTableView.rx.willDisplayCell
            .map { $0.1 }
            .bind(to: input.cellWillDisplay)
            .disposed(by: disposeBag)
        
        repositoryTableView.rx.itemSelected
            .bind(to: input.cellDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: RepositoryListViewModel) {
        let output = viewModel.output
        
        output.isLoadingIndicatorVisible
            .asDriver()
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.repositoryCellViewModels
            .asDriver()
            .map { [RepositorySection(items: $0)] }
            .drive(repositoryTableView.rx.items(dataSource: repositoryTableViewDataSource))
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .asSignal()
            .emit(onNext: errorToastMessageLabel.show(message:))
            .disposed(by: disposeBag)
        
        output.isTableViewRefreshIndicatorVisible
            .asDriver()
            .drive(repositoryRefreshControll.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.isFooterLoadingIndicatorVisible
            .asDriver()
            .drive(with: self, onNext: { `self`, isVisible in
                self.repositoryTableView.tableFooterView = isVisible ? self.repositoryTableFooterLoadingView : nil
                self.repositoryTableFooterLoadingView.showLoadingIndicatorIfNeeded(isVisible)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension RepositoryListViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Repository"
        navigationItem.rightBarButtonItem = createRepositoryBarButtonItem
    }
}

// MARK: - UI Layout

private extension RepositoryListViewController {
    func layoutUI() {
        view.addSubview(repositoryTableView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorToastMessageLabel)
        
        repositoryTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
