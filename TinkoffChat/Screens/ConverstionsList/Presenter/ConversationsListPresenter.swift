//
//  ConversationsListPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import CoreData

class ConversationsListPresenter: NSObject, IConversationsListPresenter {
    private let view: IConversationsListView
    private var communicationService: ICommunicationService
    private var conversationsDataChangedService: IConversationsDataChangedService
    private let conversationsStorage: IConversationsStorage
    
    private var selectedConversationService: ISelectedConversationService
    private var onlineConversations: [Conversation] = [] {
        didSet {
            updateOnlineConversations()
        }
    }
    private var historyConversations: [Conversation] = [] {
        didSet {
            updateHistoryConversations()
        }
    }
    
    init(view: IConversationsListView,
         selectedConversationService: ISelectedConversationService,
         communicationService: ICommunicationService,
         conversationsDataChangedService: IConversationsDataChangedService,
         conversationsStorage: IConversationsStorage) {
        self.view = view
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
        
        onlineConversations = conversationsDataChangedService.getOnlineConversations()
        historyConversations = conversationsDataChangedService.getHistoryConversations()
    }
    
    func selectConversation(_ conversationPreview: ConversationPreview) {
        let conversation = conversationPreview.online
            ? onlineConversations.first(where: { $0.user.name == conversationPreview.name })
            : historyConversations.first(where: { $0.user.name == conversationPreview.name })
        selectedConversationService.selectedConversation = conversation
    }
    
    private func updateOnlineConversations() {
        let previews = onlineConversations.map { getPreviewFrom(conversation: $0, isOnline: true) }
        let sortedPreviews = sortConversationPreviews(previews)
        view.setOnlineConversations(sortedPreviews)
    }
    
    private func updateHistoryConversations() {
        let previews = historyConversations.map { getPreviewFrom(conversation: $0, isOnline: false) }
        let sortedPreviews = sortConversationPreviews(previews)
        view.setHistoryConversations(sortedPreviews)
    }
    
    private func sortConversationPreviews(_ conversationPreviews: [ConversationPreview]) -> [ConversationPreview] {
        let unreadPreviews = conversationPreviews
            .filter { $0.hasUnreadMessages }
            .sorted { $0.name < $1.name }
        let otherPreviews = conversationPreviews
            .filter { !$0.hasUnreadMessages }
            .sorted { $0.name < $1.name }
        return unreadPreviews + otherPreviews
    }
    
    private func getPreviewFrom(conversation: Conversation, isOnline: Bool) -> ConversationPreview {
        let hasUnreadMessages = conversation.messages.contains { $0.direction == .incoming && $0.isUnread }
        return ConversationPreview(name: conversation.user.name,
                                   online: isOnline,
                                   hasUnreadMessages: hasUnreadMessages,
                                   message: conversation.messages.last?.text,
                                   date: conversation.messages.last?.date)
    }
}

extension ConversationsListPresenter: ICommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer user: UserInfo) {
        if let existingConversation = conversationsDataChangedService.getHistoryConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.setOnlineStatus(true, to: existingConversation.id)
            return
        }
        let conversation = Conversation(user: user)
        conversationsStorage.createConversation(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer user: UserInfo) {
        if let onlineConversation = conversationsDataChangedService.getOnlineConversations().filter({ $0.user.name == user.name }).first {
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
        if let conversation = conversationsDataChangedService.getOnlineConversations().filter({ $0.user.name == user.name }).first {
            conversationsStorage.appendMessage(message, to: conversation.id)
        }
    }
}

extension ConversationsListPresenter: ConversationsDataChangedServiceDelegate {
    func updateConversation(in section: Int) {
        switch section {
        case 0:
            onlineConversations = conversationsDataChangedService.getOnlineConversations()
        default:
            historyConversations = conversationsDataChangedService.getHistoryConversations()
        }
    }
    
    func updateConversations() {
        onlineConversations = conversationsDataChangedService.getOnlineConversations()
        historyConversations = conversationsDataChangedService.getHistoryConversations()
    }
    
    func startUpdates() {
        view.startUpdates()
    }
    func endUpdates() {
        view.endUpdates()
    }
}
