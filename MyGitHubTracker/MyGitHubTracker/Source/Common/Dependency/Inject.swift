//
//  Inject.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

@propertyWrapper
struct Inject<Service> {
    private let component: Service
    
    init() {
        self.component = Container.shared.resolve()
    }
    
    var wrappedValue: Service {
        return component
    }
}
