//
//  PaginationUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

protocol PaginationUseCase {
    func toggle(_ paginationState: PaginationState, isLoading: Bool) -> PaginationState
    func prepareNextPage(_ paginationState: PaginationState) -> PaginationState
    func resetToInitial(_ paginationState: PaginationState) -> PaginationState
}
