//
//  AnyTransformer.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

// MARK: Eraser Pattern for Transformable

struct AnyTransformer<DTO, ENTITY>: Transformable {
    private let _transform: (_: DTO) -> ENTITY
    
    init<T: Transformable>(_ transformer: T) where T.Input == DTO, T.Output == ENTITY {
        self._transform = transformer.transform
    }
    
    func transform(_ dto: DTO) -> ENTITY {
        return _transform(dto)
    }
}
