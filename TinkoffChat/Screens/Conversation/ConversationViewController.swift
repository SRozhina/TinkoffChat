//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private var conversationPreview: ConversationPreview?
    private var messages: [Message] = []
    private let incomingMessageCellIdentifier = String(describing: IncomingMessageCell.self)
    private let outgoingMessageCellIdentifier = String(describing: OutgoingMessageCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        reisterNibs()
        setupData()
    }
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = conversationPreview?.name
    }
    
    private func reisterNibs() {
        tableView.register(UINib(nibName: incomingMessageCellIdentifier, bundle: nil),
                           forCellReuseIdentifier: incomingMessageCellIdentifier)
        tableView.register(UINib(nibName: outgoingMessageCellIdentifier, bundle: nil),
                           forCellReuseIdentifier: outgoingMessageCellIdentifier)
    }
    
    private func setupData() {
        messages = MessagesInMemoryStorage().getMessages()
    }

}

extension ConversationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell & ChatCell
        let message = messages[indexPath.row]
        if message.direction == .incoming {
            cell = tableView.dequeueReusableCell(withIdentifier: incomingMessageCellIdentifier,
                                                 for: indexPath) as! IncomingMessageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: outgoingMessageCellIdentifier,
                                                 for: indexPath) as! OutgoingMessageCell
        }
        cell.setup(with: message)
        
        return cell
    }
}

