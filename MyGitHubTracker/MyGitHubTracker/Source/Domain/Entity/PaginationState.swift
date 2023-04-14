//
//  PaginationState.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

struct PaginationState {
    private let startPage: Int
    private let repositoryCountPerPage: Int
    var currentPage: Int
    var isLoading = false
    
    var fetchParameters: (perPage: Int, currentPage: Int) {
        return (repositoryCountPerPage, currentPage)
    }
    
    init(startPage: Int = 1, repositoryCountPerPage: Int = 10, isLoading: Bool = false) {
        self.startPage = startPage
        self.repositoryCountPerPage = repositoryCountPerPage
        self.currentPage = startPage
        self.isLoading = isLoading
    }
    
    mutating func toggle(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    mutating func resetToInitial() {
        currentPage = startPage
        isLoading = false
    }
    
    mutating func prepareNextPage() {
        isLoading = true
        currentPage += 1
    }
}
