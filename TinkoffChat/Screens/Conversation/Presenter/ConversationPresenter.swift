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
    private let view: IConversationView
    private var conversation: Conversation!
    private let conversationsStorage: IConversationsStorage
    private var messagesDataChangedService: IMessagesDataChangedService
    private var communicationService: ICommunicationService
    private var conversationsListService: IConversationsListService
    private var userDataChangedService: IUsersDataChangedService
    
    init(view: IConversationView,
         selectedConversationService: ISelectedConversationService,
         conversationsStorage: IConversationsStorage,
         messagesDataChangedService: IMessagesDataChangedService,
         communicationService: ICommunicationService,
         conversationsListService: IConversationsListService,
         userDataChangedService: IUsersDataChangedService) {
        self.view = view
        self.selectedConversationService = selectedConversationService
        self.conversationsStorage = conversationsStorage
        self.messagesDataChangedService = messagesDataChangedService
        self.communicationService = communicationService
        self.conversationsListService = conversationsListService
        self.userDataChangedService = userDataChangedService
    }
    
    func setup() {
        if selectedConversationService.selectedConversation == nil {
            view.disableSendButton()
            return
        }
        conversation = selectedConversationService.selectedConversation!
        communicationService.delegate = self
        communicationService.online = true
        messagesDataChangedService.setupService(with: conversation.id)
        messagesDataChangedService.messagesDelegate = self
        userDataChangedService.setupService()
        userDataChangedService.usersDelegate = self
        setAllMessagesAsRead()
        viewSetup()
    }
    
    private func setAllMessagesAsRead() {
        conversationsStorage.setAllMessagesAsRead(in: conversation.id)
    }
    
    func sendMessage(_ message: String) {
        let currentMessage = Message(text: message)
        conversationsStorage.appendMessage(currentMessage, to: conversation.id)
        communicationService.send(currentMessage, to: conversation.user)
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
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer user: UserInfo) {
        if let existingConversation = conversationsListService.getHistoryConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.setOnlineStatus(true, to: existingConversation.id)
            return
        }
        
        let conversation = Conversation(user: user)
        conversationsStorage.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer user: UserInfo) {
        if let onlineConversation = conversationsListService.getOnlineConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.setOnlineStatus(false, to: onlineConversation.id)
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
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: Message, from user: UserInfo) {
        if let conversation = conversationsListService.getOnlineConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.appendMessage(message, to: conversation.id)
        }
    }
}

extension ConversationPresenter: MessagesDataChangedServiceDelegate {
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
}

extension ConversationPresenter: UsersDataChangedServiceDelegate {
    func updateUser(with name: String? = nil, at indexPath: IndexPath) {
        print("test: when user become online/offline move or update will be called?")
        //TODO better to use ConversationDataChangedService, check conversationId and set state
        if name == conversation.user.name {
            if conversation.isOnline {
                conversation.isOnline = false
                view.disableSendButton()
            } else {
                conversation.isOnline = true
                view.enableSendButton()
            }
        }
    }
    
    func insertUser(at indexPath: IndexPath) { }
    
    func deleteUser(at indexPath: IndexPath) { }
    
    func moveUser(with name: String? = nil, from indexPath: IndexPath, to newIndexPath: IndexPath) {
        print("test: when user become online/offline move or update will be called?")
        if name == conversation.user.name {
            if conversation.isOnline {
                conversation.isOnline = false
                view.disableSendButton()
            } else {
                conversation.isOnline = true
                view.enableSendButton()
            }
        }
    }
}
