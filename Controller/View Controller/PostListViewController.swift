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
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControllerPulled), for: .valueChanged)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts(isReset: true) {
            self.reloadTableView()
        }
    }
    
    //MARK: - Actions
    @objc func refreshControllerPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts(isReset: false) {
            self.reloadTableView()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func addNewPostButtonTapped(_ sender: UIBarButtonItem) {
        presentNewPostAlert()
    }
    
    //MARK: - Private Functions
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    func presentNewPostAlert() {
        var userNameTextField = UITextField()
        var messageTextField = UITextField()

        let postAlert = UIAlertController(title: "New Post", message: nil, preferredStyle: .alert)
        
        postAlert.addTextField { (userName) in
            userName.placeholder = "Add Username..."
            userNameTextField = userName
        }
        postAlert.addTextField { (message) in
            message.placeholder = "Add Message..."
            messageTextField = message
        }
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let userName = userNameTextField.text,
                let message = messageTextField.text,
            !userName.isEmpty,
                !message.isEmpty else {self.presentErrorAlert(); return}
            self.postController.addPostWith(username: userName, text: message, completion: {
                self.reloadTableView()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        postAlert.addAction(postAction)
        postAlert.addAction(cancelAction)
        
        present(postAlert, animated: true)
    }
    
    func presentErrorAlert(){
        let errorAlert = UIAlertController(title: "Error", message: "Some information is missing", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in }))
        present(errorAlert, animated: true)

    }
}

//MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = postController.posts[indexPath.row].text
        cell.detailTextLabel?.text = "\(postController.posts[indexPath.row].username) \(postController.posts[indexPath.row].date)"
        return cell
    }
}

//MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= postController.posts.count - 1{
            postController.fetchPosts(isReset: false) {
                self.reloadTableView()
            }
        }
        
    }
}
