//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 03/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class ConversationsListViewController: TinkoffViewController {
    @IBOutlet private weak var tableView: UITableView!
    var presenter: IConversationsListPresenter?
    var errorAlertBuilder: IErrorAlertBuilder!
    private let conversationsListCellName = String(describing: ConversationsListCell.self)
    private var onlineConversationPreviews: [ConversationPreview] = []
    private var historyConversationsPreviews: [ConversationPreview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeTinkoffTapGesture()
        registerNibs()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.setup()
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

// MARK: - IConversationsListView
extension ConversationsListViewController: IConversationsListView {
    func setOnlineConversations(_ conversations: [ConversationPreview]) {
        self.onlineConversationPreviews = conversations
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func setHistoryConversations(_ conversations: [ConversationPreview]) {
        self.historyConversationsPreviews = conversations
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    func showErrorAlert(with title: String, retryAction: @escaping () -> Void) {
        let alert = errorAlertBuilder.build(with: title, retryAction: retryAction)
        present(alert, animated: true)
    }
    
    func startUpdates() {
        tableView.beginUpdates()
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
    
    func insertMessage(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
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
            return onlineConversationPreviews.count
        default:
            return historyConversationsPreviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: conversationsListCellName,
                                                       for: indexPath) as? ConversationsListCell else {
                                                        return UITableViewCell()
        }
        let conversation: ConversationPreview
        switch indexPath.section {
        case 0:
            conversation = onlineConversationPreviews[indexPath.row]
        default:
            conversation = historyConversationsPreviews[indexPath.row]
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

// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = indexPath.section == 0
            ? onlineConversationPreviews[indexPath.row]
            : historyConversationsPreviews[indexPath.row]
        presenter?.selectConversation(conversation)
        tableView.deselectRow(at: indexPath, animated: true)
        let conversationStoryboard = UIStoryboard(name: "ConversationViewController", bundle: nil)
        guard let conversationViewController = conversationStoryboard.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}
