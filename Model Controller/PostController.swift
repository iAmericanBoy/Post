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
    var posts: [Post] = []
    
    func fetchPosts(completion: @escaping () -> Void) {
        guard let url = baseURL else {return}
        
        var getterEndPoint = URLRequest(url: url)
        getterEndPoint.httpMethod = "GET"
        getterEndPoint.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: getterEndPoint) { (data, _, error) in
            do {
                if let downloadError = error {
                    print(downloadError)
                    completion()
                    return
                }
                guard let data = data else {
                    completion()
                    return
                }
                //Decode
                let jsonDecoder = JSONDecoder()
                let postDictonary = try! jsonDecoder.decode([String:Post].self, from: data)
                
                var posts = postDictonary.compactMap({ $0.value })
                try posts.sort(by: { $0.timestamp > $1.timestamp })
                self.posts = posts
                completion()
                return
            } catch {
                print(error)
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    
}
