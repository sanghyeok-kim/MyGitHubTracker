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
    
    var viewModel: RepositoryDetailViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindInput(to viewModel: RepositoryDetailViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: RepositoryDetailViewModel) {
        let output = viewModel.output
        
    }
}
