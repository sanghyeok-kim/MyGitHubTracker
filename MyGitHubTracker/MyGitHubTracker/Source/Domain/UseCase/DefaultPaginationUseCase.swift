//
//  DefaultPaginationUseCase.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

final class DefaultPaginationUseCase: PaginationUseCase {
    func finishLoading(_ paginationState: PaginationState) -> PaginationState {
        var newPaginationState = paginationState
        newPaginationState.finishLoading()
        return newPaginationState
    }
    
    func prepareNextPage(_ paginationState: PaginationState) -> PaginationState {
        var newState = paginationState
        newState.prepareNextPage()
        return newState
    }
    
    func resetToInitial(_ paginationState: PaginationState) -> PaginationState {
        var newState = paginationState
        newState.resetToInitial()
        return newState
    }
}
