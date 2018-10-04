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
    private var selectedConversationService: ISelectedConversationPreviewService
    
    init(view: IConversationsListView,
         conversationsStorage: IConversationsStorage,
         selectedConversationService: ISelectedConversationPreviewService) {
        self.view = view
        self.conversationsStorage = conversationsStorage
        self.selectedConversationService = selectedConversationService
    }
    
    func setup() {
        view.setOnlineConversations(conversationsStorage.getOnlineConversations())
        view.setHistoryConversations(conversationsStorage.getHistoryConversations())
    }
    
    func selectConversation(_ conversation: ConversationPreview) {
        selectedConversationService.selectedPreview = conversation
    }
}
