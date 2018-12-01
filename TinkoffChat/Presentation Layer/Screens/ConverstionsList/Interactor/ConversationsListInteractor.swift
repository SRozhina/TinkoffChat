//
//  ConversationsListInteractor.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

class ConversationsListInteractor: IConversationsListInteractor {
    private var communicationService: ICommunicationService
    private var conversationsDataService: IOnlineConversationsDataService
    private var selectedConversationService: ISelectedConversationService
    weak var delegate: ConversationsListInteractorDelegate?
    
    init(selectedConversationService: ISelectedConversationService,
         communicationService: ICommunicationService,
         conversationsDataService: IOnlineConversationsDataService) {
        self.selectedConversationService = selectedConversationService
        self.communicationService = communicationService
        self.conversationsDataService = conversationsDataService
    }
    
    func setup() {
        communicationService.delegate = self
        communicationService.online = true
        conversationsDataService.setupService()
        conversationsDataService.conversationsDelegate = self
        
        let onlineConversation = conversationsDataService.getConversations()
        delegate?.setOnlineConversation(onlineConversation)
    }
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversationService.selectedConversation = conversation
    }
}

extension ConversationsListInteractor: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: UserInfo) {
        let conversation = Conversation(user: peer)
        conversationsDataService.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: UserInfo) {
        if let onlineConversation = conversationsDataService.getConversations().filter({ $0.user.name == peer.name }).first {
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
        if let conversation = conversationsDataService.getConversations().filter({ $0.user.name == peer.name }).first {
            conversationsDataService.appendMessage(message, to: conversation.id)
        }
    }
}

extension ConversationsListInteractor: OnlineConversationsDataServiceDelegate {
    func updateConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        delegate?.updateConversation(conversation, at: indexPath)
    }
    
    func insertConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        delegate?.insertConversation(conversation, at: indexPath)
    }
    
    func moveConversation(_ conversation: Conversation, from indexPath: IndexPath, to newIndexPath: IndexPath) {
        delegate?.moveConversation(from: indexPath, to: newIndexPath)
    }
    
    func deleteConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        delegate?.deleteConversation(at: indexPath)
    }
    
    func startUpdates() {
        delegate?.startUpdates()
    }
    
    func endUpdates() {
        delegate?.endUpdates()
    }
}
