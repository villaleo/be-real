//
//  FeedViewController.swift
//  BeRealClone
//
//  Created by Leonardo Villalobos on 3/6/23.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var posts = [Post]() {
        didSet { tableView.reloadData() }
    }

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        queryPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignoutUser" {
            if let username = User.current?.username {
                let alertController = UIAlertController(
                    title: "Logout?",
                    message: "This will log out user '\(username)'.",
                    preferredStyle: .alert
                )
                alertController.addAction(.init(title: "Logout", style: .default, handler: { _ in
                    try! User.logout()
                    SceneDelegate.showScene(named: .login)
                }))
                alertController.addAction(.init(title: "Cancel", style: .default))
                present(alertController, animated: true)
            }
        }
    }

    // MARK: Private helpers
    private func queryPosts() {
        let createdAt: ParseSwift.Query<Post>.Order = .descending("createdAt")
        let query = Post.query()
            .include("user")
            .order(createdAt)
            .limit(10)
        
        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: Conform FeedViewController to UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostCell",
            for: indexPath
        ) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

// MARK: Conform FeedViewController to UITableViewDelegate
extension FeedViewController: UITableViewDelegate { }
