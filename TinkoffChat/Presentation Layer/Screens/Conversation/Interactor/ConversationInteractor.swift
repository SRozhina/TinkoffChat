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
    private var conversationsDataService: IConversationsDataService
    weak var delegate: ConversationInteractorDelegate?
    
    init(selectedConversationService: ISelectedConversationService,
         messagesDataService: IMessagesDataService,
         communicationService: ICommunicationService,
         conversationsDataService: IConversationsDataService) {
        self.selectedConversationService = selectedConversationService
        self.messagesDataService = messagesDataService
        self.communicationService = communicationService
        self.conversationsDataService = conversationsDataService
    }
    
    func setup() {
        if selectedConversationService.selectedConversation == nil {
            delegate?.updateWith(conversation: nil)
            return
        }
        let conversation = selectedConversationService.selectedConversation!
        setupCommunicationService()
        setupMessagesDataService(with: conversation.id)
        setupConversationsDataService()
        setAllMessagesAsRead(for: conversation.id)
        delegate?.updateWith(conversation: conversation)
    }
    
    func sendMessage(_ message: Message, to conversation: Conversation) {
        conversationsDataService.appendMessage(message, to: conversation.id)
        communicationService.send(message, to: conversation.user)
    }
    
    private func setupCommunicationService() {
        communicationService.delegate = self
        communicationService.online = true
    }
    
    private func setupMessagesDataService(with conversationId: String) {
        messagesDataService.setupService(with: conversationId)
        messagesDataService.messagesDelegate = self
    }
    
    private func setupConversationsDataService() {
        conversationsDataService.setupService()
        conversationsDataService.conversationsDelegate = self
    }
    
    private func setAllMessagesAsRead(for conversationId: String) {
        conversationsDataService.setAllMessagesAsRead(in: conversationId)
    }
}

extension ConversationInteractor: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: UserInfo) {
        if let existingConversation = conversationsDataService.getHistoryConversations().filter({ $0.user.name == peer.name }).first {
            conversationsDataService.setOnlineStatus(true, to: existingConversation.id)
            return
        }
        
        let conversation = Conversation(user: peer)
        conversationsDataService.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: UserInfo) {
        if let onlineConversation = conversationsDataService.getOnlineConversations().filter({ $0.user.name == peer.name }).first {
            conversationsDataService.setOnlineStatus(false, to: onlineConversation.id)
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
        delegate?.showError(text: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveInviteFromPeer peer: UserInfo,
                              invintationClosure: (Bool) -> Void) {
        invintationClosure(true)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error) {
        delegate?.showError(text: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: Message, from peer: UserInfo) {
        if let conversation = conversationsDataService.getOnlineConversations().filter({ $0.user.name == peer.name }).first {
            conversationsDataService.appendMessage(message, to: conversation.id)
        }
    }
}

extension ConversationInteractor: MessagesDataServiceDelegate {
    func updateMessage(at indexPath: IndexPath) {
        delegate?.updateMessage(at: indexPath)
    }
    
    func insertMessage(_ message: Message, at indexPath: IndexPath) {
        if let conversation = selectedConversationService.selectedConversation {
            conversationsDataService.setAllMessagesAsRead(in: conversation.id)
        }
        delegate?.insertMessage(message, at: indexPath)
    }
    
    func deleteMessage(at indexPath: IndexPath) {
        delegate?.deleteMessage(at: indexPath)
    }
    
    func startUpdates() {
        delegate?.startUpdates()
    }
    
    func endUpdates() {
        delegate?.endUpdates()
    }
}

extension ConversationInteractor: ConversationsDataServiceDelegate {
    func updateConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        delegate?.updateConversation(conversation, at: indexPath)
    }
    
    func insertConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        delegate?.insertConversation(conversation, at: indexPath)
    }
}
