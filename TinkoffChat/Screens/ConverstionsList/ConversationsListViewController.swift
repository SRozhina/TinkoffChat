//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let conversationsListCellName = String(describing: ConversationsListCell.self)
    private var onlineConversations: [Conversation] = []
    private var historyConversations: [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        setupNavBar()
        onlineConversations = ConversationsInMemoryStorage().getOnlineConversations()
        historyConversations = ConversationsInMemoryStorage().getHistoryConversations()
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: conversationsListCellName, bundle: nil), forCellReuseIdentifier: conversationsListCellName)
    }
    
    private func setupNavBar() {
        let searchController = UISearchController(searchResultsController: self)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    @IBAction private func profileButtonTapped(_ sender: UIBarButtonItem) {
        let profileStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        guard let profileViewController = profileStoryboard.instantiateInitialViewController() else { return }
        present(profileViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConversations.count
        default:
            return historyConversations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: conversationsListCellName,
                                                       for: indexPath) as? ConversationsListCell else {
                                                        return UITableViewCell()
        }
        let conversation: Conversation
        switch indexPath.section {
        case 0:
            conversation = onlineConversations[indexPath.row]
        default:
            conversation = historyConversations[indexPath.row]
        }
        cell.setup(with: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        default:
            return "History"
        }
    }
}
