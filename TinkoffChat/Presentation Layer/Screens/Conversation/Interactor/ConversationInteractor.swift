//
//  ConversationInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ConversationInteractor: IConversationInteractor {
    private let selectedConversationService: ISelectedConversationService
    private var messagesDataService: IMessagesDataService
    private var communicationService: ICommunicationService
    private var conversationDataService: IConversationDataService
    weak var delegate: ConversationInteractorDelegate?
    
    init(selectedConversationService: ISelectedConversationService,
         messagesDataService: IMessagesDataService,
         communicationService: ICommunicationService,
         conversationDataService: IConversationDataService) {
        self.selectedConversationService = selectedConversationService
        self.messagesDataService = messagesDataService
        self.communicationService = communicationService
        self.conversationDataService = conversationDataService
    }
    
    func setup() {
        if selectedConversationService.selectedConversation == nil {
            delegate?.updateWith(conversation: nil)
            return
        }
        let conversation = selectedConversationService.selectedConversation!
        setupMessagesDataService(with: conversation.id)
        messagesDataService.setAllMessagesAsRead()
        setupConversationDataService(with: conversation.id)
        delegate?.updateWith(conversation: conversation)
    }
    
    func sendMessage(_ message: Message, to conversation: Conversation) {
        messagesDataService.appendMessage(message)
        communicationService.send(message, to: conversation.user)
    }
    
    private func setupMessagesDataService(with conversationId: String) {
        messagesDataService.setupService(with: conversationId)
        messagesDataService.messagesDelegate = self
    }
    
    private func setupConversationDataService(with conversationId: String) {
        conversationDataService.setupService(with: conversationId)
        conversationDataService.conversationDelegate = self
    }
}

extension ConversationInteractor: MessagesDataServiceDelegate {
    func insertMessage(_ message: Message, at indexPath: IndexPath) {
        if selectedConversationService.selectedConversation != nil {
            messagesDataService.setAllMessagesAsRead()
        }
        delegate?.insertMessage(message, at: indexPath)
    }
    
    func startUpdates() {
        delegate?.startUpdates()
    }
    
    func endUpdates() {
        delegate?.endUpdates()
    }
}

extension ConversationInteractor: ConversationDataServiceDelegate {
    func updateConversation(_ conversation: Conversation) {
        delegate?.updateConversation(conversation)
    }
}
