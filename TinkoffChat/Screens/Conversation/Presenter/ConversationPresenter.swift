//
//  ConversationPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ConversationPresenter: IConversationPresenter {
    private let selectedConversationService: ISelectedConversationService
    private var conversationService: IConversationService
    private let view: IConversationView
    private var conversation: Conversation!
    
    init(view: IConversationView,
         selectedConversationService: ISelectedConversationService,
         conversationService: IConversationService) {
        self.view = view
        self.selectedConversationService = selectedConversationService
        self.conversationService = conversationService
    }
    
    func setup() {
        if selectedConversationService.selectedConversation == nil {
            view.disableSendButton()
            return
        }
        conversation = selectedConversationService.selectedConversation!
        conversationService.delegate = self
        conversationService.setupService(for: conversation.id)
        setAllMessagesAsRead()
        viewSetup()
    }
    
    private func setAllMessagesAsRead() {
        conversationService.setAllMessagesAsRead(in: conversation.id)
    }
    
    func sendMessage(_ message: String) {
        let currentMessage = Message(text: message)

        conversationService.sendMessage(currentMessage, in: conversation)
        view.setMessages(conversation.messages)
    }
    
    private func viewSetup() {
        if !conversation.isOnline {
            view.disableSendButton()
        }
        view.setTitle(conversation.user.name)
        view.setMessages(conversation.messages)
    }
}

extension ConversationPresenter: ConversationServiceDelegate {
    func startUpdates() {
        view.startUpdates()
    }
    
    func endUpdates() {
        view.endUpdates()
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
    
    func updateStateFor(_ user: UserInfo) {
        if user.name == conversation.user.name {
            if conversation.isOnline {
                conversation.isOnline = false
                view.disableSendButton()
            } else {
                conversation.isOnline = true
                view.enableSendButton()
            }
        }
    }
    
    func showError(with error: String, retryAction: @escaping () -> Void) {
        view.showErrorAlert(with: error, retryAction: retryAction)
    }
}
