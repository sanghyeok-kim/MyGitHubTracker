//
//  MVVMInterface.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/26.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

protocol ViewType: AnyObject {
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel? { get set }
    
    func bindInput(to viewModel: ViewModel)
    func bindOutput(from viewModel: ViewModel)
}

extension ViewType {
    func bind(viewModel: ViewModel) {
        self.viewModel = viewModel
        bindOutput(from: viewModel)
        bindInput(to: viewModel)
    }
}
