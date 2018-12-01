//
//  ConversationsListInteractorDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 15/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import Foundation

protocol ConversationsListInteractorDelegate: BaseDataServiceDelegate {
    func setOnlineConversation(_ conversation: [Conversation])
    func showError(text: String, retryAction: @escaping () -> Void)
    func insertConversation(_ conversation: Conversation, at indexPath: IndexPath)
    func updateConversation(_ conversation: Conversation, at indexPath: IndexPath)
    func moveConversation(from indexPath: IndexPath, to newIndexPath: IndexPath)
    func deleteConversation(at indexPath: IndexPath)
}
