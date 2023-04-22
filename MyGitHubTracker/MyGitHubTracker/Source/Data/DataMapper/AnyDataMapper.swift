//
//  AnyDataMapper.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

// MARK: Eraser Pattern for DataMapper

struct AnyDataMapper<DTO, Entity>: DataMapper {
    private let _transform: (_: DTO) -> Entity
    
    init<T: DataMapper>(_ mapper: T) where T.Input == DTO, T.Output == Entity {
        self._transform = mapper.transform
    }
    
    func transform(_ dto: DTO) -> Entity {
        return _transform(dto)
    }
}
