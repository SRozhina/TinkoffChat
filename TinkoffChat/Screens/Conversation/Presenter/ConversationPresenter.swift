//
//  ConversationPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

class ConversationPresenter: IConversationPresenter {
    private let messagesStorage: IMessagesStorage
    private let selectedConversationPreviewService: ISelectedConversationPreviewService
    private let view: IConversationView
    private var messages: [Message] = []
    private var conversationPreview: ConversationPreview?
    
    init(view: IConversationView, messagesStorage: IMessagesStorage, selectedConversationPreviewService: ISelectedConversationPreviewService) {
        self.view = view
        self.messagesStorage = messagesStorage
        self.selectedConversationPreviewService = selectedConversationPreviewService
    }
    
    func setup() {
        conversationPreview = selectedConversationPreviewService.selectedPreview
        messages = messagesStorage.getMessages()
        view.setTitle(conversationPreview?.name)
        view.setMessages(messages)
    }
}
