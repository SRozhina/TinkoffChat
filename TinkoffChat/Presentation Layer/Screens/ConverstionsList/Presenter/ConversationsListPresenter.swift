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
    private let interactor: IConversationsListInteractor

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
        let previews = onlineConversations.map { getPreviewFrom(conversation: $0, isOnline: true) }
        //TODO maybe we should not sort as new data should be sorted
        //let sortedPreviews = sortConversationPreviews(previews)
        view.setOnlineConversations(previews)
    }
    
    private func updateHistoryConversations() {
        let previews = historyConversations.map { getPreviewFrom(conversation: $0, isOnline: false) }
        //TODO maybe we should not sort as new data should be sorted
        //let sortedPreviews = sortConversationPreviews(previews)
        view.setHistoryConversations(previews)
    }
    
//    private func sortConversationPreviews(_ conversationPreviews: [ConversationPreview]) -> [ConversationPreview] {
//        let unreadPreviews = conversationPreviews
//            .filter { $0.hasUnreadMessages }
//            .sorted { $0.name < $1.name }
//        let otherPreviews = conversationPreviews
//            .filter { !$0.hasUnreadMessages }
//            .sorted { $0.name < $1.name }
//        return unreadPreviews + otherPreviews
//    }
    
    private func getPreviewFrom(conversation: Conversation, isOnline: Bool) -> ConversationPreview {
        let hasUnreadMessages = conversation.messages.contains { $0.direction == .incoming && $0.isUnread }
        return ConversationPreview(id: conversation.id,
                                   name: conversation.user.name,
                                   online: isOnline,
                                   hasUnreadMessages: hasUnreadMessages,
                                   message: conversation.messages.last?.text,
                                   date: conversation.messages.last?.date)
    }
}

extension ConversationsListPresenter: ConversationsListInteractorDelegate {
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
