//
//  ConversationPresenter.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

class ConversationPresenter: IConversationPresenter {
    private var messagesStorage: IMessagesStorage
    private var view: IConversationView
    private var messages: [Message] = []
    private var conversationPreview: ConversationPreview?
    
    init(view: IConversationView, messagesStorage: IMessagesStorage) {
        self.view = view
        self.messagesStorage = messagesStorage
    }
    
    func setup() {
        messages = messagesStorage.getMessages()
        view.setTitle(conversationPreview?.name)
        view.setMessages(messages)
    }
}
