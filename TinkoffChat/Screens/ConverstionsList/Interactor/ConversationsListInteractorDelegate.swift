//
//  ConversationsListInteractorDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

protocol ConversationsListInteractorDelegate: BaseDataChangedServiceDelegate {
    func setOnlineConversation(_ conversation: [Conversation])
    func setHistoryConversations(_ conversation: [Conversation])
    func showError(text: String, retryAction: @escaping () -> Void)
}
