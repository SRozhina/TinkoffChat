//
//  OnlineConversationsDataServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 01/12/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol OnlineConversationsDataServiceDelegate: BaseDataServiceDelegate {
    func updateConversation(_ conversation: Conversation, at indexPath: IndexPath)
    func insertConversation(_ conversation: Conversation, at newIndexPath: IndexPath)
    func moveConversation(_ conversation: Conversation, from indexPath: IndexPath, to newIndexPath: IndexPath)
    func deleteConversation(_ conversation: Conversation, at indexPath: IndexPath)
}
