//
//  DefaultPaginationUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

final class DefaultPaginationUseCase: PaginationUseCase {
    func toggle(_ paginationState: PaginationState, isLoading: Bool) -> PaginationState {
        var newPaginationState = paginationState
        newPaginationState.toggle(isLoading: isLoading)
        return newPaginationState
    }
    
    func prepareNextPage(_ paginationState: PaginationState) -> PaginationState {
        var newState = paginationState
        newState.isLoading = true
        newState.currentPage += 1
        return newState
    }
    
    func resetToInitial(_ paginationState: PaginationState) -> PaginationState {
        var newState = paginationState
        newState.resetToInitial()
        return newState
    }
}
