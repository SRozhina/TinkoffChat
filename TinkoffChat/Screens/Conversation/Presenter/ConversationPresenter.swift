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
    
    init(view: IConversationView, communicationService: ICommunicationService, selectedConversationService: ISelectedConversationService) {
        self.view = view
        self.communicationService = communicationService
        self.selectedConversationService = selectedConversationService
    }
    
    func setup() {
        communicationService.delegate = self
        communicationService.online = true
        if selectedConversationService.selectedConversation == nil {
            view.disableSendButton()
            return
        }
        conversation = selectedConversationService.selectedConversation!
        for message in conversation.messages {
            message.isUnread = false
        }
        viewSetup()
    }
    
    func sendMessage(_ message: String) {
        let currentMessage = Message(text: message)
        conversation.messages.append(currentMessage)
        view.setMessages(conversation.messages)
        communicationService.send(currentMessage, to: conversation.user)
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
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: UserInfo) {
        if peer == conversation.user {
            self.view.disableSendButton()
            conversation.isOnline = false
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
        conversation.messages.append(message)
        view.setMessages(conversation.messages)
    }
}
