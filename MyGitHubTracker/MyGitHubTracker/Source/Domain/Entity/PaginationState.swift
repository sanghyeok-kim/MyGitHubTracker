//
//  PaginationState.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/14.
//

import Foundation

struct PaginationState {
    private let startPage: Int
    private let countPerPage: Int
    private var currentPage: Int
    private var isLoading = false
    
    var fetchParameters: (perPage: Int, currentPage: Int) {
        return (countPerPage, currentPage)
    }
    
    var canLoad: Bool {
        return !isLoading
    }
    
    init(startPage: Int = 1, countPerPage: Int = 10) {
        self.startPage = startPage
        self.countPerPage = countPerPage
        self.currentPage = startPage
    }
    
    mutating func finishLoading() {
        isLoading = false
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
