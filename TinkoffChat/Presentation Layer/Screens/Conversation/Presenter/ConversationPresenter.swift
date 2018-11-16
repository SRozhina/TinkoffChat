//
//  ConversationPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ConversationPresenter: IConversationPresenter {
    private let view: IConversationView
    private let interactor: IConversationInteractor
    private var conversation: Conversation!
    
    init(view: IConversationView,
         interactor: IConversationInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func setup() {
        interactor.setup()
    }
    
    func updateWith(conversation: Conversation?) {
        guard let selectedConversation = conversation else {
            view.setSendButtonEnabled(false)
            return
        }
        self.conversation = selectedConversation
        viewSetup()
    }
    
    func sendMessage(_ message: String) {
        let currentMessage = Message(text: message)
        interactor.sendMessage(currentMessage, to: conversation)
        view.setMessages(conversation.messages)
    }
    
    private func viewSetup() {
        if !conversation.isOnline {
            view.setSendButtonEnabled(false)
        }
        view.setTitle(conversation.user.name)
        view.setMessages(conversation.messages)
    }
}

extension ConversationPresenter: ConversationInteractorDelegate {
    func updateConversationState(for conversationId: String) {
        if conversationId == conversation.id {
            conversation.isOnline = !conversation.isOnline
            view.setSendButtonEnabled(conversation.isOnline)
        }
    }
    
    func showError(text: String, retryAction: @escaping () -> Void) {
        view.showErrorAlert(with: text, retryAction: retryAction)
    }
    
    func updateMessage(at indexPath: IndexPath) {
        view.updateMessage(at: indexPath)
    }
    
    func insertMessage(at indexPath: IndexPath) {
        view.insertMessage(at: indexPath)
    }
    
    func deleteMessage(at indexPath: IndexPath) {
        view.deleteMessage(at: indexPath)
    }
    
    func updateForUser(name: String?) {
        if name == conversation.user.name {
            conversation.isOnline = !conversation.isOnline
            view.setSendButtonEnabled(conversation.isOnline)
        }
    }
    
    func startUpdates() {
        view.startUpdates()
    }
    
    func endUpdates() {
        view.endUpdates()
    }
}
