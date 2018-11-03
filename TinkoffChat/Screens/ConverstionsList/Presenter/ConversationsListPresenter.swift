//
//  ConversationsListPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

class ConversationsListPresenter: IConversationsListPresenter {
    private let view: IConversationsListView
    private let conversationsStorage: IConversationsStorage
    private var selectedConversationService: ISelectedConversationService
    private var communicationService: ICommunicationService
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
         conversationsStorage: IConversationsStorage,
         selectedConversationService: ISelectedConversationService,
         communicationService: ICommunicationService) {
        self.view = view
        self.conversationsStorage = conversationsStorage
        self.selectedConversationService = selectedConversationService
        self.communicationService = communicationService
    }
    
    func setup() {
        communicationService.delegate = self
        communicationService.online = true
        let conversations = conversationsStorage.getConversations()
        onlineConversations = conversations.filter { $0.isOnline }
        historyConversations = conversations.filter { !$0.isOnline }
    }
    
    func selectConversation(_ conversationPreview: ConversationPreview) {
        let conversation = conversationPreview.online
            ? onlineConversations.first(where: { $0.user.name == conversationPreview.name })
            : historyConversations.first(where: { $0.user.name == conversationPreview.name })
        selectedConversationService.selectedConversation = conversation
    }
    
    func saveAll() {
        let conversations = onlineConversations + historyConversations
        conversationsStorage.updateConversations(by: conversations)
    }
    
    private func updateOnlineConversations() {
        let previews = onlineConversations.map { getPreviewFrom(conversation: $0, isOnline: true) }
        let sortedPreviews = sortConversationPreviews(previews)
        view.setOnlineConversations(sortedPreviews)
    }
    
    private func updateHistoryConversations() {
        let previews = onlineConversations.map { getPreviewFrom(conversation: $0, isOnline: false) }
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
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: Peer) {
        let conversation: Conversation
        if let existingConversationIndex = historyConversations.firstIndex(where: { $0.user == peer }) {
            conversation = historyConversations.remove(at: existingConversationIndex)
            conversation.isOnline = true
        } else {
            conversation = Conversation(user: peer)
        }
        onlineConversations.append(conversation)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: Peer) {
        if let onlineConversationIndex = onlineConversations.firstIndex(where: { $0.user == peer }) {
            let onlineConversation = onlineConversations.remove(at: onlineConversationIndex)
            onlineConversation.isOnline = false
            historyConversations.append(onlineConversation)
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
        view.showErrorAlert(with: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveInviteFromPeer peer: Peer,
                              invintationClosure: (Bool) -> Void) {
        invintationClosure(true)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error) {
        view.showErrorAlert(with: error.localizedDescription) {
            self.communicationService.online = true
        }
    }
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: Message, from peer: Peer) {
        guard let conversation = onlineConversations.first(where: { $0.user == peer }) else { return }
        conversation.messages.append(message)
        updateOnlineConversations()
    }
}
