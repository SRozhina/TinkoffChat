//
//  ConversationPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ConversationPresenter: IConversationPresenter {
    private unowned let view: IConversationView
    private var interactor: IConversationInteractor
    private var conversation: Conversation!
    
    init(view: IConversationView,
         interactor: IConversationInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func setup() {
        interactor.delegate = self
        interactor.setup()
    }
    
    func updateWith(conversation: Conversation?) {
        guard let selectedConversation = conversation else {
            view.isOnline = false
            return
        }
        self.conversation = selectedConversation
        viewSetup()
    }
    
    func sendMessage(_ message: String) {
        let currentMessage = Message(text: message)
        interactor.sendMessage(currentMessage, to: conversation)
    }
    
    private func viewSetup() {
        view.setTitle(conversation.user.name)
        view.setMessages(conversation.messages)
        view.isOnline = conversation.isOnline
    }
    
    private func setIsOnline(to value: Bool) {
        conversation.isOnline = value
        view.isOnline = value
    }
}

extension ConversationPresenter: ConversationInteractorDelegate {    
    func updateConversation(_ conversation: Conversation) {
        setIsOnline(to: conversation.isOnline)
    }
    
    func showError(text: String, retryAction: @escaping () -> Void) {
        view.showErrorAlert(with: text, retryAction: retryAction)
    }
    
    func insertMessage(_ message: Message, at indexPath: IndexPath) {
        conversation.messages.insert(message, at: indexPath.row)
        view.setMessages(conversation.messages)
        view.insertMessage(at: indexPath)
    }
    
    func startUpdates() {
        view.startUpdates()
    }
    
    func endUpdates() {
        view.endUpdates()
    }
}
