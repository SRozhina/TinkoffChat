//
//  ConversationsDataChangedServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol ConversationsDataServiceDelegate: BaseDataServiceDelegate {
    func updateConversation(_ conversation: Conversation, in section: Int)
    func updateConversations()
}
