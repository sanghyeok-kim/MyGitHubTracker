//
//  Inject.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

@propertyWrapper
struct Inject<Service> {
    var wrappedValue: Service {
        return Container.shared.resolve()
    }
}
