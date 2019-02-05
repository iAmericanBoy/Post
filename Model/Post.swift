//
//  Post.swift
//  Post
//
//  Created by Dominic Lanzillotta on 2/4/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class Post: Codable {
    let text: String
    let username: String
    let timestamp: TimeInterval
    var date: String {
        get {
            let dateInCurrentTimeZone = Calendar.current.dateComponents(in: TimeZone.current, from: Date(timeIntervalSince1970: timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            return dateInCurrentTimeZone.date!.description(with: Locale.current)
        }
    }
    
    init(text: String,username: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
    }
    
    
}
