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
    private var conversationsListService: IConversationsListService
    
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
         conversationsListService: IConversationsListService) {
        self.view = view
        self.selectedConversationService = selectedConversationService
        self.conversationsListService = conversationsListService
    }
    
    func setup() {
        conversationsListService.delegate = self
        conversationsListService.setupService()
        
        onlineConversations = conversationsListService.getOnlineConversations()
        historyConversations = conversationsListService.getHistoryConversations()
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

extension ConversationsListPresenter: ConversationsListServiceDelegate { 
    func updateConversation(in section: Int) {
        switch section {
        case 0:
            onlineConversations = conversationsListService.getOnlineConversations()
        default:
            historyConversations = conversationsListService.getHistoryConversations()
        }
    }
    
    func updateConversations() {
        onlineConversations = conversationsListService.getOnlineConversations()
        historyConversations = conversationsListService.getHistoryConversations()
    }
    
    func showError(with error: String, retryAction: @escaping () -> Void) {
        view.showErrorAlert(with: error, retryAction: retryAction)
    }
    
    func startUpdates() {
        view.startUpdates()
    }
    func endUpdates() {
        onlineConversations = conversationsListService.getOnlineConversations()
        view.endUpdates()
    }
}
