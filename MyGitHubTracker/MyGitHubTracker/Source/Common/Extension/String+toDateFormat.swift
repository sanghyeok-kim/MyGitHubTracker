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
        inputFormatter.dateFormat = Constant.DateFormat.iso8601Format
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = Constant.DateFormat.userDisplayFormat
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        return outputFormatter.string(from: date)
    }
}
