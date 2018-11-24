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
    private var messagesDataChangedService: IMessagesDataService
    private var communicationService: ICommunicationService
    private var conversationsDataChangedService: IConversationsDataService
    weak var delegate: ConversationInteractorDelegate?
    
    init(selectedConversationService: ISelectedConversationService,
         messagesDataChangedService: IMessagesDataService,
         communicationService: ICommunicationService,
         conversationsDataChangedService: IConversationsDataService) {
        self.selectedConversationService = selectedConversationService
        self.messagesDataChangedService = messagesDataChangedService
        self.communicationService = communicationService
        self.conversationsDataChangedService = conversationsDataChangedService
    }
    
    func setup() {
        if selectedConversationService.selectedConversation == nil {
            delegate?.updateWith(conversation: nil)
            return
        }
        let conversation = selectedConversationService.selectedConversation!
        setupCommunicationService()
        setupMessagesDataChangedService(with: conversation.id)
        setupConversationsDataChangedService()
        setAllMessagesAsRead(for: conversation.id)
        delegate?.updateWith(conversation: conversation)
    }
    
    func sendMessage(_ message: Message, to conversation: Conversation) {
        conversationsDataChangedService.appendMessage(message, to: conversation.id)
        communicationService.send(message, to: conversation.user)
    }
    
    private func setupCommunicationService() {
        communicationService.delegate = self
        communicationService.online = true
    }
    
    private func setupMessagesDataChangedService(with conversationId: String) {
        messagesDataChangedService.setupService(with: conversationId)
        messagesDataChangedService.messagesDelegate = self
    }
    
    private func setupConversationsDataChangedService() {
        conversationsDataChangedService.setupService()
        conversationsDataChangedService.conversationsDelegate = self
    }
    
    private func setAllMessagesAsRead(for conversationId: String) {
        conversationsDataChangedService.setAllMessagesAsRead(in: conversationId)
    }
}

extension ConversationInteractor: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: UserInfo) {
        if let existingConversation = conversationsDataChangedService.getHistoryConversations().filter({ $0.user.name == peer.name }).first {
            conversationsDataChangedService.setOnlineStatus(true, to: existingConversation.id)
            return
        }
        
        let conversation = Conversation(user: peer)
        conversationsDataChangedService.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: UserInfo) {
        if let onlineConversation = conversationsDataChangedService.getOnlineConversations().filter({ $0.user.name == peer.name }).first {
            conversationsDataChangedService.setOnlineStatus(false, to: onlineConversation.id)
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
        if let conversation = conversationsDataChangedService.getOnlineConversations().filter({ $0.user.name == peer.name }).first {
            conversationsDataChangedService.appendMessage(message, to: conversation.id)
        }
    }
}

extension ConversationInteractor: MessagesDataServiceDelegate {
    func updateMessage(at indexPath: IndexPath) {
        delegate?.updateMessage(at: indexPath)
    }
    
    func insertMessage(_ message: Message, at indexPath: IndexPath) {
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
