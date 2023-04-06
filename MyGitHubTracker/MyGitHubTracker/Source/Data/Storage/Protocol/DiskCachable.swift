//
//  DiskCachable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation

protocol DiskCachable {
    func lookUpData(by key: String, completion: @escaping (Data?) -> Void)
    func storeData(_ data: Data, forKey key: String)
}
