//
//  PostController.swift
//  Post
//
//  Created by Dominic Lanzillotta on 2/4/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class PostController {
    //BaseURl
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    //sourceOfTruth
    let posts: [Post] = []
    
    func fetchPosts(completion: @escaping () -> Void) {
        
    }
    
    
}
