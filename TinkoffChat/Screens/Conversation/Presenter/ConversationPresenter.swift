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
    private var communicationService: ICommunicationService
    private let view: IConversationView
    private var conversation: Conversation!
    private let conversationsStorage: IConversationsStorage
    
    init(view: IConversationView,
         communicationService: ICommunicationService,
         selectedConversationService: ISelectedConversationService,
         conversationsStorage: IConversationsStorage) {
        self.view = view
        self.communicationService = communicationService
        self.selectedConversationService = selectedConversationService
        self.conversationsStorage = conversationsStorage
    }
    
    func setup() {
        communicationService.delegate = self
        communicationService.online = true
        if selectedConversationService.selectedConversation == nil {
            view.disableSendButton()
            return
        }
        conversation = selectedConversationService.selectedConversation!
        setAllMessagesAsRead()
        viewSetup()
    }
    
    private func setAllMessagesAsRead() {
        for message in conversation.messages {
            message.isUnread = false
        }
        
        conversationsStorage.setAllMessagesAsRead(in: conversation.id)
    }
    
    func sendMessage(_ message: String) {
        let currentMessage = Message(text: message)
        addMessage(currentMessage)
        communicationService.send(currentMessage, to: conversation.user)
    }
    
    private func addMessage(_ message: Message) {
        conversation.messages.append(message)
        conversationsStorage.appendMessage(message, to: conversation.id)
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

extension ConversationPresenter: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: UserInfo) {
        if peer == conversation.user {
            self.view.enableSendButton()
            conversation.isOnline = true
            conversationsStorage.setOnlineStatus(true, to: conversation.id)
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: UserInfo) {
        if peer == conversation.user {
            self.view.disableSendButton()
            conversation.isOnline = false
            conversationsStorage.setOnlineStatus(false, to: conversation.id)
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
        view.showErrorAlert(with: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveInviteFromPeer peer: UserInfo,
                              invintationClosure: (Bool) -> Void) {
        invintationClosure(true)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error) {
        view.showErrorAlert(with: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: Message, from peer: UserInfo) {
        message.isUnread = false
        addMessage(message)
    }
}
