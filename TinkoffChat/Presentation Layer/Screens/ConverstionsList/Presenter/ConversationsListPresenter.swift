//
//  ConversationsListPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import CoreData

class ConversationsListPresenter: IConversationsListPresenter {
    private let view: IConversationsListView
    private var interactor: IConversationsListInteractor

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
         interactor: IConversationsListInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func setup() {
        interactor.delegate = self
        interactor.setup()
    }
    
    func selectConversation(_ conversationPreview: ConversationPreview) {
        let conversation = conversationPreview.online
            ? onlineConversations.first(where: { $0.id == conversationPreview.id })
            : historyConversations.first(where: { $0.id == conversationPreview.id })
        guard let selecedConversation = conversation else { return }
        interactor.selectConversation(selecedConversation)
    }
    
    private func updateOnlineConversations() {
        let previews = onlineConversations.map { getPreviewFrom(conversation: $0) }
        view.setOnlineConversations(previews)
    }
    
    private func updateHistoryConversations() {
        let previews = historyConversations.map { getPreviewFrom(conversation: $0) }
        view.setHistoryConversations(previews)
    }
    
    private func getPreviewFrom(conversation: Conversation) -> ConversationPreview {
        let hasUnreadMessages = conversation.messages.contains { $0.direction == .incoming && $0.isUnread }
        return ConversationPreview(id: conversation.id,
                                   name: conversation.user.name,
                                   online: conversation.isOnline,
                                   hasUnreadMessages: hasUnreadMessages,
                                   message: conversation.messages.last?.text,
                                   date: conversation.messages.last?.date)
    }
}

extension ConversationsListPresenter: ConversationsListInteractorDelegate {
    func updateConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        onlineConversations = interactor.getOnlineConversations()
        historyConversations = interactor.getHistoryConversations()
    }
    
    func insertConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        onlineConversations.insert(conversation, at: indexPath.row)
    }
    
    func setOnlineConversation(_ conversation: [Conversation]) {
        onlineConversations = conversation
    }
    
    func setHistoryConversations(_ conversation: [Conversation]) {
        historyConversations = conversation
    }
    
    func showError(text: String, retryAction: @escaping () -> Void) {
        view.showErrorAlert(with: text, retryAction: retryAction)
    }
    
    func startUpdates() {
        view.startUpdates()
    }
    
    func endUpdates() {
        view.endUpdates()
    }
}
