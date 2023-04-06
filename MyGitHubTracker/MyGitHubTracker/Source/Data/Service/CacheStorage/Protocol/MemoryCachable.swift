//
//  MemoryCachable.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/04/06.
//

import Foundation
import UIKit.UIImage

protocol MemoryCachable {
    func lookUpImage(by imageName: String) -> UIImage?
    func storeImage(_ image: UIImage, forKey key: String)
}
