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
    func insertMessage(_ message: Message, at indexPath: IndexPath)
    func deleteMessage(at indexPath: IndexPath)
    func updateForUser(name: String?)
    
    func insertConversation(_ conversation: Conversation, at indexPath: IndexPath)
    func updateConversation(_ conversation: Conversation, at indexPath: IndexPath)
}
