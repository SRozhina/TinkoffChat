//
//  IConversationsListView.swift
//  TinkoffChat
//
//  Created by Sofia on 04/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//
import Foundation

protocol IConversationsListView: class {
    func setOnlineConversations(_ conversations: [ConversationPreview])
    func showErrorAlert(with title: String, retryAction: @escaping () -> Void)
    func startUpdates()
    func endUpdates()
    
    func insertMessage(at indexPath: IndexPath)
    
    func updateConversation(at indexPath: IndexPath)
    func insertConversation(at indexPath: IndexPath)
    func moveConversation(from indexPath: IndexPath, to newIndexPath: IndexPath)
    func deleteConversation(at indexPath: IndexPath)
}
