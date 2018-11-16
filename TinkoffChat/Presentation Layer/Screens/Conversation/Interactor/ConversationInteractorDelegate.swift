//
//  ConversationInteractorDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol ConversationInteractorDelegate: BaseDataServiceDelegate {
    func updateWith(conversation: Conversation?)
    func showError(text: String, retryAction: @escaping () -> Void)
    func updateMessage(at indexPath: IndexPath)
    func insertMessage(at indexPath: IndexPath)
    func deleteMessage(at indexPath: IndexPath)
    func updateForUser(name: String?)
    func updateConversationState(for conversationId: String)
}
