//
//  Post.swift
//  Post
//
//  Created by Dominic Lanzillotta on 2/4/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class Post {
    let text: String
    let username: String
    let timestamp: TimeInterval = Date().timeIntervalSince1970
    
    init(text: String,username: String) {
        self.username = username
        self.text = text
    }
}
