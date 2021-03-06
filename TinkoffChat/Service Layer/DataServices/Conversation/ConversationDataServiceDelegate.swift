//
//  ConversationsDataServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 14/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol ConversationDataServiceDelegate: BaseDataServiceDelegate {
    func updateConversation(_ conversation: Conversation)
}
