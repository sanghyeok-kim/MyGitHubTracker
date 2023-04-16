//
//  PaginationUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

protocol PaginationUseCase {
    func finishLoading(_ paginationState: PaginationState) -> PaginationState
    func prepareNextPage(_ paginationState: PaginationState) -> PaginationState
    func resetToInitial(_ paginationState: PaginationState) -> PaginationState
}
