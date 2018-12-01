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
    func insertMessage(_ message: Message, at indexPath: IndexPath)
    
    func updateConversation(_ conversation: Conversation)
}
