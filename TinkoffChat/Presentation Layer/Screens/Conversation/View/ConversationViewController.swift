//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class ConversationViewController: TinkoffViewController {
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
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .green
        label.textAlignment = .center
        return label
    }()
    var isOnline = false {
        didSet {
            changeSendButtonState()
            updateConversationTitle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTextView()
        setupSendButton()
        reisterNibs()
        addKeyboardObservers()
        addGestureRecognizers()
        
        presenter?.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
        updateConversationTitle()
    }
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backItem?.title = "Back"
        navigationItem.titleView = titleLabel
    }
    
    private func setupTextView() {
        messageTextView.placeholderText = placeholderText
        messageTextView.sendAction = { [unowned self] in self.sendMessage($0) }
        messageTextView.layer.cornerRadius = 5
        messageTextView.textViewDelegate = self
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
                       completion: { [unowned self] _ in self.scrollToBottom() })
    }
    
    @IBAction private func sendButtonTapped(_ sender: Any) {
        if messageTextView.isEmpty { return }
        sendMessage(messageTextView.text)
    }
    
    private func sendMessage(_ message: String) {
        presenter.sendMessage(message)
        messageTextView.clear()
        dismissKeyboard()
    }
    
    private func scrollToBottom() {
        if messages.count <= 0 { return }
        DispatchQueue.main.async { [unowned self] in
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func changeSendButtonState() {
        let sendButtonEnabled = isOnline && !messageTextView.isEmpty
        let color: UIColor = sendButtonEnabled ? .gray : .white
        if sendButton.isEnabled == sendButtonEnabled { return }
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.sendButton.tintColor = color
                        self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                       },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.sendButton.transform = .identity
                        })
                       })
        sendButton.isEnabled = !sendButton.isEnabled
    }
    
    func updateConversationTitle() {
        let size: CGFloat = isOnline ? 1.1 : 1
        let color: UIColor = isOnline ? .green : .black
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.navigationItem.titleView?.transform = CGAffineTransform(scaleX: size, y: size)
        }, completion: { _ in
            UIView.transition(with: self.titleLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.titleLabel.textColor = color
            }, completion: nil)
        })
    }
    
}

extension ConversationViewController: IConversationView {
    func startUpdates() {
        tableView.beginUpdates()
    }
    
    func endUpdates() {
        tableView.endUpdates()
        scrollToBottom()
    }
    
    func insertMessage(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func setMessages(_ messages: [Message]) {
        self.messages = messages
    }
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func showErrorAlert(with title: String, retryAction: @escaping () -> Void) {
        let alert = errorAlertBuilder.build(with: title, retryAction: retryAction)
        present(alert, animated: true)
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

extension ConversationViewController: ExpandableTextViewDelegate {
    func textDidChanged() {
        changeSendButtonState()
    }
}
