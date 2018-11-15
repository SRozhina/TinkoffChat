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
    private var conversationsDataChangedService: IConversationsDataChangedService
    private let conversationsStorage: IConversationsStorage
    private var selectedConversationService: ISelectedConversationService
    weak var delegate: ConversationsListInteractorDelegate?
    
    init(selectedConversationService: ISelectedConversationService,
         communicationService: ICommunicationService,
         conversationsDataChangedService: IConversationsDataChangedService,
         conversationsStorage: IConversationsStorage) {
        self.selectedConversationService = selectedConversationService
        self.conversationsStorage = conversationsStorage
        self.communicationService = communicationService
        self.conversationsDataChangedService = conversationsDataChangedService
    }
    
    func setup() {
        communicationService.delegate = self
        communicationService.online = true
        conversationsDataChangedService.setupService()
        conversationsDataChangedService.conversationsDelegate = self
        
        let onlineConversations = conversationsDataChangedService.getOnlineConversations()
        delegate?.setOnlineConversation(onlineConversations)
        let historyConversations = conversationsDataChangedService.getHistoryConversations()
        delegate?.setHistoryConversations(historyConversations)
    }
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversationService.selectedConversation = conversation
    }
}

extension ConversationsListInteractor: ICommunicationServiceDelegate {
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

extension ConversationsListInteractor: ConversationsDataChangedServiceDelegate {
    func updateConversation(in section: Int) {
        switch section {
        case 0:
            let onlineConversations = conversationsDataChangedService.getOnlineConversations()
            delegate?.setOnlineConversation(onlineConversations)
        default:
            let historyConversations = conversationsDataChangedService.getHistoryConversations()
            delegate?.setHistoryConversations(historyConversations)
        }
    }
    
    func updateConversations() {
        let onlineConversations = conversationsDataChangedService.getOnlineConversations()
        delegate?.setOnlineConversation(onlineConversations)
        let historyConversations = conversationsDataChangedService.getHistoryConversations()
        delegate?.setHistoryConversations(historyConversations)
    }
    
    func startUpdates() {
        delegate?.startUpdates()
    }
    
    func endUpdates() {
        delegate?.endUpdates()
    }
}
