//
//  ConversationsListPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import CoreData

class ConversationsListPresenter: IConversationsListPresenter {
    private unowned let view: IConversationsListView
    private var interactor: IConversationsListInteractor

    private var onlineConversations: [Conversation] = [] {
        didSet {
            let previews = onlineConversations.map { getPreviewFrom(conversation: $0) }
            view.setOnlineConversations(previews)
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
        let conversation = onlineConversations.first(where: { $0.id == conversationPreview.id })
        guard let selecedConversation = conversation else { return }
        interactor.selectConversation(selecedConversation)
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
        onlineConversations[indexPath.row] = conversation
        view.updateConversation(at: indexPath)
    }
    
    func insertConversation(_ conversation: Conversation, at indexPath: IndexPath) {
        onlineConversations.insert(conversation, at: indexPath.row)
        view.insertConversation(at: indexPath)
    }
    
    func moveConversation(from indexPath: IndexPath, to newIndexPath: IndexPath) {
        let conversation = onlineConversations.remove(at: indexPath.row)
        onlineConversations.insert(conversation, at: newIndexPath.row)
        view.moveConversation(from: indexPath, to: newIndexPath)
    }
    
    func deleteConversation(at indexPath: IndexPath) {
        onlineConversations.remove(at: indexPath.row)
        view.deleteConversation(at: indexPath)
    }
    
    func setOnlineConversation(_ conversation: [Conversation]) {
        onlineConversations = conversation
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
