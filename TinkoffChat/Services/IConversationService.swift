//
//  IConversationService.swift
//  TinkoffChat
//
//  Created by Sofia on 12/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol IConversationService {
    func setupService(for conversationId: String)
    func setAllMessagesAsRead(in conversationId: String)
    func sendMessage(_ message: Message, in conversation: Conversation)
    var delegate: ConversationServiceDelegate? { get set }
}
