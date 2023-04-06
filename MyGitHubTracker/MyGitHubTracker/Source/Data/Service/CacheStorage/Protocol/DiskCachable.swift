//
//  DiskCachable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation
import UIKit.UIImage

protocol DiskCachable {
    func lookUpImage(by imageName: String, completion: @escaping (UIImage?) -> Void)
    func storeImage(_ image: UIImage, forKey key: String)
}
