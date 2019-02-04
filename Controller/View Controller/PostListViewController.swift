//
//  POstListViewController.swift
//  Post
//
//  Created by Dominic Lanzillotta on 2/4/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        postController.fetchPosts {
            self.tableView.reloadData()
        }
    }
}


extension PostListViewController: UITableViewDelegate {
    
}
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = postController.posts[indexPath.row].text
        cell.detailTextLabel?.text = postController.posts[indexPath.row].username
        return cell
    }
    
    
}