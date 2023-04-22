//
//  StarredRepositoryListViewController.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/20.
//

import RxSwift
import RxAppState
import RxDataSources
import Then
import SnapKit

final class StarredRepositoryListViewController: UIViewController, ViewType {
    
    private lazy var repositoryRefreshControll = UIRefreshControl()
    
    private lazy var loadingIndicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.hidesWhenStopped = true
    }
    
    private lazy var repositoryTableViewDataSource: RxTableViewSectionedReloadDataSource<StarredRepositorySection> = {
        return .init { (cell: StarredRepositoryTableViewCell, cellViewModel: StarredRepositoryCellViewModel) in
            cell.bind(viewModel: cellViewModel)
        }
    }()
    
    private lazy var repositoryTableView = UITableView().then {
        $0.refreshControl = repositoryRefreshControll
        $0.estimatedRowHeight = 120
        $0.rowHeight = UITableView.automaticDimension
        $0.register(StarredRepositoryTableViewCell.self, forCellReuseIdentifier: StarredRepositoryTableViewCell.identifier)
        $0.tableFooterView = repositoryTableFooterLoadingView
    }
    
    private lazy var repositoryTableFooterLoadingView = LoadingIndicatorView().then {
        $0.frame.size.height = 120
    }
    
    private lazy var toastMessageLabel = ToastLabel()
    
    var viewModel: StarredRepositoryListViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
    }
    
    func bindInput(to viewModel: StarredRepositoryListViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        repositoryRefreshControll.rx.controlEvent(.valueChanged)
            .bind(to: input.tableViewDidRefresh)
            .disposed(by: disposeBag)
        
        repositoryTableView.rx.willDisplayCell
            .map { $0.1 }
            .bind(to: input.cellWillDisplay)
            .disposed(by: disposeBag)
        
        repositoryTableView.rx.itemSelected
            .do { [weak self] indexPath in
                self?.repositoryTableView.deselectRow(at: indexPath, animated: true)
            }
            .bind(to: input.cellDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: StarredRepositoryListViewModel) {
        let output = viewModel.output
        
        output.starredRepositorySections
            .asDriver()
            .drive(repositoryTableView.rx.items(dataSource: repositoryTableViewDataSource))
            .disposed(by: disposeBag)
        
        output.isLoadingIndicatorVisible
            .asDriver()
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.showToastMessage
            .asSignal()
            .emit(onNext: toastMessageLabel.show(message:))
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

private extension StarredRepositoryListViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = Constant.Text.starredRepository
    }
}

// MARK: - UI Layout

private extension StarredRepositoryListViewController {
    func layoutUI() {
        view.addSubview(repositoryTableView)
        view.addSubview(loadingIndicator)
        view.addSubview(toastMessageLabel)
        
        repositoryTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        toastMessageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.8)
        }
    }
}
