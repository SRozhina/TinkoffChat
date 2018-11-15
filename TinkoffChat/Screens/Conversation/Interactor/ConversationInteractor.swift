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
    private let conversationsStorage: IConversationsStorage
    private var messagesDataChangedService: IMessagesDataChangedService
    private var communicationService: ICommunicationService
    private var conversationsDataChangedService: IConversationsDataChangedService
    private var userDataChangedService: IUsersDataChangedService
    weak var delegate: ConversationInteractorDelegate?
    
    init(selectedConversationService: ISelectedConversationService,
         conversationsStorage: IConversationsStorage,
         messagesDataChangedService: IMessagesDataChangedService,
         communicationService: ICommunicationService,
         conversationsDataChangedService: IConversationsDataChangedService,
         userDataChangedService: IUsersDataChangedService) {
        self.selectedConversationService = selectedConversationService
        self.conversationsStorage = conversationsStorage
        self.messagesDataChangedService = messagesDataChangedService
        self.communicationService = communicationService
        self.conversationsDataChangedService = conversationsDataChangedService
        self.userDataChangedService = userDataChangedService
    }
    
    func setup() {
        if selectedConversationService.selectedConversation == nil {
            delegate?.updateWith(conversation: nil)
            return
        }
        let conversation = selectedConversationService.selectedConversation!
        setupCommunicationService()
        setupMessagesDataChangedService(with: conversation.id)
        setupUserDataChangedService()
        setAllMessagesAsRead(for: conversation.id)
        delegate?.updateWith(conversation: conversation)
    }
    
    func sendMessage(_ message: Message, to conversation: Conversation) {
        conversationsStorage.appendMessage(message, to: conversation.id)
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
    
    private func setupUserDataChangedService() {
        userDataChangedService.setupService()
        userDataChangedService.usersDelegate = self
    }
    
    private func setAllMessagesAsRead(for conversationId: String) {
        conversationsStorage.setAllMessagesAsRead(in: conversationId)
    }
}

extension ConversationInteractor: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: UserInfo) {
        if let existingConversation = conversationsDataChangedService.getHistoryConversations().filter({ $0.user.name == peer.name }).first {
            conversationsStorage.setOnlineStatus(true, to: existingConversation.id)
            return
        }
        
        let conversation = Conversation(user: peer)
        conversationsStorage.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: UserInfo) {
        if let onlineConversation = conversationsDataChangedService.getOnlineConversations().filter({ $0.user.name == peer.name }).first {
            conversationsStorage.setOnlineStatus(false, to: onlineConversation.id)
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
            conversationsStorage.appendMessage(message, to: conversation.id)
        }
    }
}

extension ConversationInteractor: MessagesDataChangedServiceDelegate {
    func updateMessage(at indexPath: IndexPath) {
        delegate?.updateMessage(at: indexPath)
    }
    
    func insertMessage(at indexPath: IndexPath) {
        delegate?.insertMessage(at: indexPath)
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

extension ConversationInteractor: UsersDataChangedServiceDelegate {
    func updateUser(with name: String? = nil, at indexPath: IndexPath) {
        print("test: when user become online/offline move or update will be called?")
        //TODO better to use ConversationDataChangedService, check conversationId and set state
        delegate?.updateForUser(name: name)
    }
    
    func insertUser(at indexPath: IndexPath) { }
    
    func deleteUser(at indexPath: IndexPath) { }
    
    func moveUser(with name: String? = nil, from indexPath: IndexPath, to newIndexPath: IndexPath) {
        print("test: when user become online/offline move or update will be called?")
        delegate?.updateForUser(name: name)
    }
}

extension ConversationInteractor: ConversationsDataChangedServiceDelegate {
    func updateConversation(in section: Int) {
        //TODO check will or won't be updated conversation online state (conversationsdatachanged -> conversationsListPresenter -> selectedCoversation -> current)
        //        if conversationId == conversation.id {
        //            conversation.isOnline = !conversation.isOnline
        //            view.setSendButtonEnabled(conversation.isOnline)
        //        }
    }
    
    func updateConversations() {
        //TODO check will or won't be updated conversation online state (conversationsdatachanged -> conversationsListPresenter -> selectedCoversation -> current)
    }
}
