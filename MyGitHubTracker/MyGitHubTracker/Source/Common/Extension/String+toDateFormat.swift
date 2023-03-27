//
//  String+toDateFormat.swift
//  MyGitHubTracker
//
//  Created by 김상혁 on 2023/03/27.
//

import Foundation

extension String {
    var toDateFormat: String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy"
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        return outputFormatter.string(from: date)
    }
}
