//
//  Transformable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

protocol Transformable {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
