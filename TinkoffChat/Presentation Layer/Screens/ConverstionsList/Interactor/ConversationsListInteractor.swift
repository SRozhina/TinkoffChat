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
    private var conversationsDataService: IConversationsDataService
    private var selectedConversationService: ISelectedConversationService
    weak var delegate: ConversationsListInteractorDelegate?
    
    init(selectedConversationService: ISelectedConversationService,
         communicationService: ICommunicationService,
         conversationsDataService: IConversationsDataService) {
        self.selectedConversationService = selectedConversationService
        self.communicationService = communicationService
        self.conversationsDataService = conversationsDataService
    }
    
    func setup() {
        communicationService.delegate = self
        communicationService.online = true
        conversationsDataService.setupService()
        conversationsDataService.conversationsDelegate = self
        
        let onlineConversations = conversationsDataService.getOnlineConversations()
        delegate?.setOnlineConversation(onlineConversations)
        let historyConversations = conversationsDataService.getHistoryConversations()
        delegate?.setHistoryConversations(historyConversations)
    }
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversationService.selectedConversation = conversation
    }
}

extension ConversationsListInteractor: ICommunicationServiceDelegate {
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

extension ConversationsListInteractor: ConversationsDataServiceDelegate {    
    func updateConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        delegate?.updateConversation(conversation, at: indexPath)
    }
    
    func insertConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        delegate?.insertConversation(conversation, at: indexPath)
    }
    
    func getOnlineConversations() -> [Conversation] {
        return conversationsDataService.getOnlineConversations()
    }
    
    func getHistoryConversations() -> [Conversation] {
        return conversationsDataService.getHistoryConversations()
    }
    
    func startUpdates() {
        delegate?.startUpdates()
    }
    
    func endUpdates() {
        delegate?.endUpdates()
    }
}
