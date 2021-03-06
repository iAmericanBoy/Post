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
    
    //CRUD
    //MARK: - Create
    func addPostWith(username: String, text: String, completion: @escaping () -> Void) {
        let newPost = Post(text: text, username: username)
        
        var postData: Data
        
        do {
            let encoder = JSONEncoder()
            postData = try encoder.encode(newPost)
        } catch  {
            print("Error encoding PostData: \(error) \(error.localizedDescription) ")
            completion()
            return
        }
        
        guard let url = baseURL else {completion(); return}
        let postEndpoint = url.appendingPathExtension("json")
        
        var request = URLRequest(url: postEndpoint)
        request.httpBody = postData
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error posting to API: \(error) \(error.localizedDescription)")
                completion()
                return
            }
            guard let data = data, let dataString = String(data: data, encoding: .utf8) else {print("error unwrapping data"); completion(); return}
            
            
            self.fetchPosts(isReset: true, completion: {
                completion()
            })
        }
        dataTask.resume()
        
        
    }
    
    //MARK: - Read
    func fetchPosts(isReset: Bool = true, completion: @escaping () -> Void) {
        let queryEndInterval = isReset ? Date().timeIntervalSince1970 : posts.last?.queryTimeStamp ?? Date().timeIntervalSince1970

        
        guard let baseURL = baseURL else {return}
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {return}
        
        let getterEndpoint = url.appendingPathExtension("json")
        
        var request = URLRequest(url: getterEndpoint)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
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
            posts.sort(by: { $0.timestamp > $1.timestamp })
            if isReset {
                self.posts = posts
            } else {
                self.posts += posts
            }
            completion()
            return
            
        }
        dataTask.resume()
    }
    
    
}
