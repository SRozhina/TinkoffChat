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
    @IBOutlet private weak var messageTextView: ExpandableTextView!
    @IBOutlet private weak var messageViewBottom: NSLayoutConstraint!
    @IBOutlet private weak var sendButton: UIButton!
    
    var presenter: IConversationPresenter!
    var errorAlertBuilder: IErrorAlertBuilder!
    private var messages: [Message] = []
    private let incomingMessageCellIdentifier = String(describing: IncomingMessageCell.self)
    private let outgoingMessageCellIdentifier = String(describing: OutgoingMessageCell.self)
    private var placeholderText = "Message"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTextView()
        setupSendButton()
        reisterNibs()
        addKeyboardObservers()
        addGestureRecognizers()
        
        presenter.setup()
    }
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupTextView() {
        messageTextView.placeholderText = placeholderText
        messageTextView.sendAction = sendMessage
        messageTextView.layer.cornerRadius = 5
    }
    
    private func setupSendButton() {
        sendButton.layer.cornerRadius = 5
    }
    
    private func reisterNibs() {
        tableView.register(UINib(nibName: incomingMessageCellIdentifier, bundle: nil),
                           forCellReuseIdentifier: incomingMessageCellIdentifier)
        tableView.register(UINib(nibName: outgoingMessageCellIdentifier, bundle: nil),
                           forCellReuseIdentifier: outgoingMessageCellIdentifier)
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    private func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        messageTextView.resignFirstResponder()
        messageTextView.layoutSubviews()
    }
    
    @objc
    private func handleKeyboardNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameValue = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        messageViewBottom.constant = notification.name == Notification.Name.UIKeyboardWillShow
            ? keyboardFrame.height
            : 0
        
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    @IBAction private func sendButtonTapped(_ sender: Any) {
        if messageTextView.text == placeholderText { return }
        sendMessage(messageTextView.text)
    }
    
    private func sendMessage(_ message: String) {
        presenter.sendMessage(message)
        messageTextView.clear()
        dismissKeyboard()
    }
    
}

extension ConversationViewController: IConversationView {
    func startUpdates() {
        tableView.beginUpdates()
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
    
    func updateMessage(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func insertMessage(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func deleteMessage(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setMessages(_ messages: [Message]) {
        self.messages = messages
        tableView.reloadData()
    }
    
    func setTitle(_ title: String?) {
        navigationItem.title = title
    }
    
    func showErrorAlert(with title: String, retryAction: @escaping () -> Void) {
        let alert = errorAlertBuilder.build(with: title, retryAction: retryAction)
        present(alert, animated: true)
    }
    
    func enableSendButton() {
        sendButton.isEnabled = true
        sendButton.tintColor = .gray
    }
    
    func disableSendButton() {
        sendButton.isEnabled = false
        sendButton.tintColor = .white
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
